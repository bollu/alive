#! /usr/bin/env python

# Copyright 2014 The Alive authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse, glob, re, sys
from language import *
from parser import parse_llvm, parse_opt_file


def block_model(s, sneg, m):
  # First simplify the model.
  sneg.push()
  bools = []
  exprs = []
  for n in m.decls():
    b = FreshBool()
    expr = (Int(str(n)) == m[n])
    sneg.add(b == expr)
    bools += [b]
    exprs += [expr]

  req = []
  req_exprs = []
  for i in range(len(bools)):
    if sneg.check(req + bools[i+1:]) != unsat:
      req += [bools[i]]
      req_exprs += [exprs[i]]
  assert sneg.check(req) == unsat
  sneg.pop()

  # Now block the simplified model.
  s.add(Not(mk_and(req_exprs)))


def get_z3_id(x):
  return Z3_get_ast_id(x.ctx.ref(), x.as_ast())


def z3_solver_to_smtlib(s):
  a = s.assertions()
  size = len(a) - 1
  _a = (Ast * size)()
  for k in range(size):
    _a[k] = a[k].as_ast()

  return Z3_benchmark_to_smtlib_string(a[size].ctx_ref(), None, None, None, '',
                                       size, _a,  a[size].as_ast())


def gen_benchmark(s):
  if not os.path.isdir('bench'):
    return

  header = ("(set-info :source |\n Generated by Alive 0.1\n"
            " More info in TBD.\n|)\n\n")
  string = header + z3_solver_to_smtlib(s)

  files = glob.glob('bench/*.smt2')
  if len(files) == 0:
    filename = 0
  else:
    files.sort(reverse=True)
    filename = int(re.search('(\d+)\.smt2', files[0]).group(1)) + 1
  filename = 'bench/%03d.smt2' % filename
  fd = open(filename, 'w')
  fd.write(string)
  fd.close()


def check_incomplete_solver(res, s):
  if res == unknown:
    print '\nWARNING: The SMT solver gave up. Verification incomplete.'
    print 'Solver says: ' + s.reason_unknown()
    exit(-1)


tactic = AndThen(
  Repeat(AndThen(Tactic('simplify'), Tactic('propagate-values'))),
  Tactic('elim-term-ite'),
  Tactic('simplify'),
  Tactic('propagate-values'),
  Tactic('solve-eqs'),
  Cond(Probe('is-qfbv'), Tactic('qfbv'), Tactic('bv'))
)

correct_exprs = {}
def check_expr(qvars, expr, error):
  expr = mk_forall(qvars, mk_and(expr))
  id = get_z3_id(expr)
  if id in correct_exprs:
    return
  correct_exprs[id] = expr

  s = tactic.solver()
  s.add(expr)

  if __debug__:
    gen_benchmark(s)

  res = s.check()
  if res != unsat:
    check_incomplete_solver(res, s)
    e, src, tgt, stop, srcv, tgtv, types = error(s)
    print '\nERROR: %s' % e
    print 'Example:'
    print_var_vals(s, srcv, tgtv, stop, types)
    print 'Source value: ' + src
    print 'Target value: ' + tgt
    exit(-1)


def var_type(var, types):
  t = types[Int('t_' + var)].as_long()
  if t == Type.Int:
    return 'i%s' % types[Int('size_' + var)]
  if t == Type.Ptr:
    return var_type('*' + var, types) + '*'
  if t == Type.Array:
    elems = types[Int('val_%s_%s' % (var, 'elems'))]
    return '[%s x %s]' % (elems, var_type('[' + var + ']', types))
  assert False


def str_model(s, v):
  val = s.model().evaluate(v, True).as_long()
  return "%d (%s)" % (val, hex(val))


def _print_var_vals(s, vars, stopv, seen, types):
  for k,v in vars.iteritems():
    if k == stopv:
      return
    if k in seen:
      continue
    seen |= set([k])
    print "%s %s = %s" % (k, var_type(k, types), str_model(s, v[0]))


def print_var_vals(s, vs1, vs2, stopv, types):
  seen = set()
  _print_var_vals(s, vs1, stopv, seen, types)
  _print_var_vals(s, vs2, stopv, seen, types)


def check_typed_opt(pre, src, tgt, types):
  srcv = toSMT(src)
  tgtv = toSMT(tgt)
  pre  = pre.toSMT(srcv)
  extra_cnstrs = [pre,
                  srcv.getAllocaConstraints(),
                  tgtv.getAllocaConstraints()]

  for k,v in srcv.iteritems():
    # skip instructions only on one side; assumes they remain unchanged
    if k[0] == 'C' or not tgtv.has_key(k):
      continue

    (a, defa, poisona, qvars) = v
    (b, defb, poisonb, qvarsb) = tgtv[k]
    defb = mk_and(defb)
    poisonb = mk_and(poisonb)

    # Check if domain of defined values of Src implies that of Tgt.
    check_expr(qvars, defa + [mk_not(defb)] + extra_cnstrs, lambda s :
      ("Domain of definedness of Target is smaller than Source's for %s %s\n"
         % (var_type(k, types), k),
       str_model(s, a), 'undef', k, srcv, tgtv, types))

    # Check if domain of poison values of Src implies that of Tgt.
    check_expr(qvars, defa + poisona + [mk_not(poisonb)] + extra_cnstrs,
      lambda s :
      ("Domain of poisoness of Target is smaller than Source's for %s %s\n"
         % (var_type(k, types), k),
       str_model(s, a), 'poison', k, srcv, tgtv, types))

    # Check that final values of vars are equal.
    check_expr(qvars, defa + poisona + [a != b] + extra_cnstrs, lambda s :
      ("Mismatch in values of %s %s\n" % (var_type(k, types), k),
       str_model(s, a), str_model(s, b), k, srcv, tgtv, types))

  # now check that the final memory state is similar in both programs
  memsb = {str(ptr) : mem for (ptr, mem, info) in tgtv.ptrs}
  for (ptr, mem, info) in srcv.ptrs:
    memb = memsb.get(str(ptr))
    if memb == None:
      # If memory was not written in Source, then ignore the block.
      if is_const(simplify(mem)):
        continue
      print '\nERROR: No memory state for %s in Target' % str(ptr)
      exit(-1)

    check_expr([], [mem != memb] + extra_cnstrs, lambda s :
      ('Mismatch in final memory state for %s (%d bits)' %
         (ptr, mem.sort().size()),
       str_model(s, mem), str_model(s, memb), None, srcv, tgtv, types))


def check_opt(opt):
  name, pre, src, tgt, used_src, used_tgt = opt

  print '----------------------------------------'
  print 'Optimization: ' + name
  print 'Precondition: ' + str(pre)
  print_prog(src)
  print '  =>'
  print_prog(tgt)
  print

  # infer allowed types for registers
  type_src = getTypeConstraints(src)
  type_tgt = getTypeConstraints(tgt)
  type_pre = pre.getTypeConstraints()

  s = SolverFor('QF_LIA')
  s.add(type_pre)
  s.add(type_src)
  if s.check() != sat:
    print 'Source program does not type check'
    exit(-1)

  s.add(type_tgt)
  if s.check() != sat:
    print 'Source and Target programs do not type check'
    exit(-1)

  sneg = SolverFor('QF_LIA')
  sneg.add(Not(mk_and([type_pre] + type_src + type_tgt)))

  has_unreach = any(v.startswith('unreachable') for v in tgt.iterkeys())
  for v in src.iterkeys():
    if v[0] == '%' and v not in used_src and v not in used_tgt and v not in tgt\
       and not has_unreach:
      print 'ERROR: Temporary register %s unused and not overwritten' % v
      exit(-1)

  for v in tgt.iterkeys():
    if v[0] == '%' and v not in used_tgt and v not in src:
      print 'ERROR: Temporary register %s unused and does not overwrite any'\
            ' Source register' % v
      exit(-1)

  # now check for correctness
  proofs = 0
  while True:
    res = s.check()
    if res != sat:
      break
    types = s.model()
    fixupTypes(src, types)
    fixupTypes(tgt, types)
    pre.fixupTypes(types)
    check_typed_opt(pre, src, tgt, types)
    block_model(s, sneg, types)
    proofs += 1
    sys.stdout.write('\rDone: ' + str(proofs))
    sys.stdout.flush()

  if res == unsat:
    print '\nOptimization is correct!\n'
  else:
    print '\nVerification incomplete; did not check all bit widths\n'


def main():
  parser = argparse.ArgumentParser()
  parser.add_argument('-m', '--match', action='append', metavar='name',
    help='run tests containing this text')
  parser.add_argument('-V', '--verify', action='store_true', default=True,
    help='check correctness of optimizations (default: True)')
  parser.add_argument('--no-verify', action='store_false', dest='verify')
  parser.add_argument('file', type=file, nargs='*', default=[sys.stdin],
    help='optimization file (read from stdin if none given)',)

  args = parser.parse_args()
  for f in args.file:
    opts = parse_opt_file(f.read())

    for opt in opts:
      if not args.match or any(pat in opt[0] for pat in args.match):
        if args.verify:
          check_opt(opt)
        else:
          print opt[0]


if __name__ == "__main__":
  try:
    main()
  except IOError, e:
    print >> sys.stderr, 'ERROR:', e
    exit(-1)
  except KeyboardInterrupt:
    print '\nCaught Ctrl-C. Exiting..'
