# Copyright 2013-2015 The Alive authors.
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

import collections
from constants import *
from codegen import *

def getAllocSize(type):
  # round to nearest byte boundary
  return int((type.getSize() + 7) / 8) * 8


def alignSize(size, align):
  if align == 0:
    return size
  assert align & (align-1) == 0
  return (size + (align-1)) & ~(align-1)


def getPtrAlignCnstr(ptr, align):
  if align == 0:
    return BoolVal(True)
  assert align & (align-1) == 0
  return ptr & (align-1) == 0


def defined_align_access(state, defined, access_size, req_align, aptr):
  defined.append(aptr != 0)
  must_access = []
  for blck in state.ptrs:
    ptr  = blck.ptr
    size = blck.size()
    inbounds = And(UGE(aptr, ptr), UGE((size - access_size)/8, aptr - ptr))
    if req_align != 0 and size >= access_size:
      # overestimating the alignment is undefined behavior.
      defined.append(Implies(inbounds, blck.align >= req_align))
    if access_size <= size:
      must_access.append(inbounds if blck.isAlloca() else BoolVal(True))
  defined.append(mk_or(must_access))
  # load/store are cutpoints; record BB definedness
  state.defined += defined


################################
class MemInfo:
  def __init__(self, ptr, ty, block_size, num_elems, align):
    self.ptr = ptr
    self.ty = ty
    self.block_size = block_size
    self.num_elems = num_elems
    self.align = align

  def isAlloca(self):
    return self.ty == 'alloca'

  def size(self):
    return self.block_size * self.num_elems

  def __eq__(self, b):
    return self.ptr.eq(b.ptr)


class State:
  def __init__(self):
    self.vars = collections.OrderedDict()
    self.defined = [] # definedness so far in the BB
    self.ptrs = []
    self.mem_qvars = []
    self.bb_pres = {}
    self.bb_mem = {}

  def add(self, v, smt, defined, poison, qvars):
    if v.getUniqueName() == '':
      return
    self.vars[v.getUniqueName()] = (smt, self.defined + defined, poison, qvars)
    if isinstance(v, TerminatorInst):
      for (bb,cond) in v.getSuccessors(self):
        bb = bb[1:]
        if bb not in self.bb_pres:
          self.bb_pres[bb] = []
          self.bb_mem[bb] = []
        self.bb_pres[bb] += [cond]
        self.bb_mem[bb].append((cond, self.mem))

  def addAlloca(self, ptr, mem, block_size, num_elems, align):
    self.mem_qvars.append(mem)
    self.ptrs.append(MemInfo(ptr, 'alloca', block_size, num_elems, align))

  def addInputMem(self, ptr, qvars, block_size, num_elems):
    # precondition vcgen can call this function spuriously
    if any(ptr.eq(blck.ptr) for blck in self.ptrs):
      return
    self.mem_qvars += qvars
    self.ptrs.append(MemInfo(ptr, 'in', block_size, num_elems, 1))

  def store(self, cnstr, idx, val):
    if use_array_theory():
      self.mem = mk_if(mk_and(cnstr), Update(self.mem, idx, val), self.mem)
    else:
      self.mem = If(mk_and(cnstr + [self.idx_var == idx]), val, self.mem)

  def load(self, idx):
    if use_array_theory():
      return self.mem[idx]
    return substitute(self.mem, (self.idx_var, idx))

  def newBB(self, name):
    if name in self.bb_pres:
      self.defined = [mk_or(self.bb_pres[name])]
      self.mem = fold_ite_list(self.bb_mem[name])
    else:
      self.defined = []
      if use_array_theory():
        self.mem = Array('mem0', BitVecSort(get_ptr_size()), BitVecSort(8))
      else:
        self.mem = BitVec('mem0', 8)
        self.idx_var = BitVec('idx', get_ptr_size())
    self.current_bb = name

  def getAllocaConstraints(self):
    # generate the following constraints:
    # 1) Alloca ptrs are never null
    # 2) Allocated regions do not overlap with each other and with input blocks
    cnstr = []
    for mem1 in self.ptrs:
      if mem1.ty == 'in':
        continue
      ptr = mem1.ptr
      size = mem1.size()
      cnstr.append(ptr != 0)
      for mem2 in self.ptrs:
        if mem1 == mem2:
          continue
        cnstr.append(Or(UGE(mem2.ptr, ptr + size),
                        ULE(mem2.ptr + mem2.size(), ptr)))
    return cnstr

  def eval(self, v, defined, poison, qvars):
    (smt, d, p, q) = self.vars[v.getUniqueName()]
    defined += d
    poison += p
    qvars += q
    return smt

  def iteritems(self):
    for k,v in self.vars.iteritems():
      if k[0] != '%' and k[0] != 'C' and not k.startswith('ret_'):
        continue
      yield k,v

  def has_key(self, k):
    return self.vars.has_key(k)

  def __getitem__(self, k):
    return self.vars[k]


################################
class Instr(Value):
  pass

################################
class CopyOperand(Instr):
  def __init__(self, v, type):
    self.v = v
    self.type = type
    assert isinstance(self.v, Value)
    assert isinstance(self.type, Type)

  def __repr__(self):
    t = str(self.type)
    if len(t) > 0:
      t += ' '
    return t + self.v.getName()

  def toSMT(self, defined, poison, state, qvars):
    return state.eval(self.v, defined, poison, qvars)

  def getTypeConstraints(self, bitwidth):
    return And(self.type == self.v.type,
               self.type.getTypeConstraints(bitwidth))

  def register_types(self, manager):
    manager.register_type(self, self.type, UnknownType())
    manager.unify(self, self.v)

  # TODO: visit_source?

  def visit_target(self, manager, use_builder=False):
    instr = manager.get_cexp(self.v)

    if use_builder:
      isntr = CVariable('Builder').arr('Insert', [instr])

    # TODO: this probably should use manager.get_ctype,
    # but that currently doesn't distinguish source instructions (Value)
    # from target instructions (Instruction)
    if isinstance(self.v, Instr):
      ctype = manager.PtrInstruction
    else:
      ctype = manager.PtrValue

    return [CDefinition.init(
      ctype,
      manager.get_cexp(self),
      instr)]

################################
class BinOp(Instr):
  Add, Sub, Mul, UDiv, SDiv, URem, SRem, Shl, AShr, LShr, And, Or, Xor,\
  Last = range(14)

  opnames = {
    Add:  'add',
    Sub:  'sub',
    Mul:  'mul',
    UDiv: 'udiv',
    SDiv: 'sdiv',
    URem: 'urem',
    SRem: 'srem',
    Shl:  'shl',
    AShr: 'ashr',
    LShr: 'lshr',
    And:  'and',
    Or:   'or',
    Xor:  'xor',
  }
  opids = {v:k for k, v in opnames.items()}


  def __init__(self, op, type, v1, v2, flags = []):
    assert isinstance(type, Type)
    assert isinstance(v1, Value)
    assert isinstance(v2, Value)
    assert 0 <= op < self.Last
    self.op = op
    self.type = type
    self.v1 = v1
    self.v2 = v2
    self.flags = list(flags)
    self._check_op_flags()

  def getOpName(self):
    return self.opnames[self.op]

  @staticmethod
  def getOpId(name):
    try:
      return BinOp.opids[name]
    except:
      raise ParseError('Unknown binary instruction')

  def __repr__(self):
    t = str(self.type)
    if len(t) > 0:
      t = ' ' + t
    flags = ' '.join(self.flags)
    if len(flags) > 0:
      flags = ' ' + flags
    return '%s%s%s %s, %s' % (self.getOpName(), flags, t,
                              self.v1.getName(),
                              self.v2.getName())

  def _check_op_flags(self):
    allowed_flags = {
      self.Add:  ['nsw', 'nuw'],
      self.Sub:  ['nsw', 'nuw'],
      self.Mul:  ['nsw', 'nuw'],
      self.UDiv: ['exact'],
      self.SDiv: ['exact'],
      self.URem: [],
      self.SRem: [],
      self.Shl:  ['nsw', 'nuw'],
      self.AShr: ['exact'],
      self.LShr: ['exact'],
      self.And:  [],
      self.Or:   [],
      self.Xor:  [],
    }[self.op]

    for f in self.flags:
      if f not in allowed_flags:
        raise ParseError('Flag not supported by ' + self.getOpName(), f)

  def _genSMTDefConds(self, v1, v2, poison):
    bits = self.type.getSize()

    poison_conds = {
      self.Add: {'nsw': lambda a,b: SignExt(1,a)+SignExt(1,b) == SignExt(1,a+b),
                 'nuw': lambda a,b: ZeroExt(1,a)+ZeroExt(1,b) == ZeroExt(1,a+b),
                },
      self.Sub: {'nsw': lambda a,b: SignExt(1,a)-SignExt(1,b) == SignExt(1,a-b),
                 'nuw': lambda a,b: ZeroExt(1,a)-ZeroExt(1,b) == ZeroExt(1,a-b),
                },
      self.Mul: {'nsw': lambda a,b: no_overflow_smul(a, b),
                 'nuw': lambda a,b: no_overflow_umul(a, b),
                },
      self.UDiv:{'exact': lambda a,b: UDiv(a, b) * b == a,
                },
      self.SDiv:{'exact': lambda a,b: (a / b) * b == a,
                },
      self.URem:{},
      self.SRem:{},
      self.Shl: {'nsw': lambda a,b: Or((a << b) >> b == a,
                                       And(a == 1, b == (bits-1)))
                                    if use_new_semantics()
                                    else (a << b) >> b == a,
                 'nuw': lambda a,b: LShR(a << b, b) == a,
                },
      self.AShr:{'exact': lambda a,b: (a >> b) << b == a,
                },
      self.LShr:{'exact': lambda a,b: LShR(a, b) << b == a,
                },
      self.And: {},
      self.Or:  {},
      self.Xor: {},
    }[self.op]

    if do_infer_flags():
      for flag,fn in poison_conds.iteritems():
        bit = get_flag_var(flag, self.getName())
        poison += [Implies(bit == 1, fn(v1, v2))]
    else:
      for f in self.flags:
        poison += [poison_conds[f](v1, v2)]

    # definedness of the instruction
    return {
      self.Add:  lambda a,b: [],
      self.Sub:  lambda a,b: [],
      self.Mul:  lambda a,b: [],
      self.UDiv: lambda a,b: [b != 0],
      self.SDiv: lambda a,b: [b != 0, Or(a != (1 << (bits-1)), b != -1)],
      self.URem: lambda a,b: [b != 0],
      self.SRem: lambda a,b: [b != 0, Or(a != (1 << (bits-1)), b != -1)],
      self.Shl:  lambda a,b: [ULT(b, bits)],
      self.AShr: lambda a,b: [ULT(b, bits)],
      self.LShr: lambda a,b: [ULT(b, bits)],
      self.And:  lambda a,b: [],
      self.Or:   lambda a,b: [],
      self.Xor:  lambda a,b: [],
      }[self.op](v1,v2)

  def toSMT(self, defined, poison, state, qvars):
    v1 = state.eval(self.v1, defined, poison, qvars)
    v2 = state.eval(self.v2, defined, poison, qvars)
    defined += self._genSMTDefConds(v1, v2, poison)
    return {
      self.Add:  lambda a,b: a + b,
      self.Sub:  lambda a,b: a - b,
      self.Mul:  lambda a,b: a * b,
      self.UDiv: lambda a,b: UDiv(a, b),
      self.SDiv: lambda a,b: a / b,
      self.URem: lambda a,b: URem(a, b),
      self.SRem: lambda a,b: SRem(a, b),
      self.Shl:  lambda a,b: a << b,
      self.AShr: lambda a,b: a >> b,
      self.LShr: lambda a,b: LShR(a, b),
      self.And:  lambda a,b: a & b,
      self.Or:   lambda a,b: a | b,
      self.Xor:  lambda a,b: a ^ b,
    }[self.op](v1, v2)

  def getTypeConstraints(self, bitwidth):
    return And(self.type == self.v1.type,
               self.type == self.v2.type,
               self.type.getTypeConstraints(bitwidth))

  caps = {
    Add:  'Add',
    Sub:  'Sub',
    Mul:  'Mul',
    UDiv: 'UDiv',
    SDiv: 'SDiv',
    URem: 'URem',
    SRem: 'SRem',
    Shl:  'Shl',
    AShr: 'AShr',
    LShr: 'LShr',
    And:  'And',
    Or:   'Or',
    Xor:  'Xor',
  }

  def register_types(self, manager):
    manager.register_type(self, self.type, IntType())
    manager.unify(self, self.v1, self.v2)

  def visit_source(self, mb):
    r1 = mb.subpattern(self.v1)
    r2 = mb.subpattern(self.v2)

    op = BinOp.caps[self.op]

    if 'nsw' in self.flags and 'nuw' in self.flags:
      return CFunctionCall('match',
        mb.get_my_ref(),
        CFunctionCall('m_CombineAnd',
          CFunctionCall('m_NSW' + op, r1, r2),
          CFunctionCall('m_NUW' + op,
            CFunctionCall('m_Value'),
            CFunctionCall('m_Value'))))

    if 'nsw' in self.flags:
      return mb.simple_match('m_NSW' + op, r1, r2)

    if 'nuw' in self.flags:
      return mb.simple_match('m_NUW' + op, r1, r2)

    if 'exact' in self.flags:
      return CFunctionCall('match',
        mb.get_my_ref(),
        CFunctionCall('m_Exact', CFunctionCall('m_' + op, r1, r2)))

    return mb.simple_match('m_' + op, r1, r2)

  def visit_target(self, manager, use_builder=False):
    cons = CFunctionCall('BinaryOperator::Create' + self.caps[self.op],
      manager.get_cexp(self.v1), manager.get_cexp(self.v2))

    if use_builder:
      cons = CVariable('Builder').arr('Insert', [cons])

    gen = [CDefinition.init(CPtrType(CTypeName('BinaryOperator')), manager.get_cexp(self), cons)]

    for f in self.flags:
      setter = {'nsw': 'setHasNoSignedWrap', 'nuw': 'setHasNoUnsignedWrap', 'exact': 'setIsExact'}[f]
      gen.append(manager.get_cexp(self).arr(setter, [CVariable('true')]))

    return gen


################################
class ConversionOp(Instr):
  Trunc, ZExt, SExt, ZExtOrTrunc, Ptr2Int, Int2Ptr, Bitcast, Last = range(8)

  opnames = {
    Trunc:       'trunc',
    ZExt:        'zext',
    SExt:        'sext',
    ZExtOrTrunc: 'ZExtOrTrunc',
    Ptr2Int:     'ptrtoint',
    Int2Ptr:     'inttoptr',
    Bitcast:     'bitcast',
  }
  opids = {v:k for k, v in opnames.items()}

  def __init__(self, op, stype, v, type):
    assert isinstance(stype, Type)
    assert isinstance(type, Type)
    assert isinstance(v, Value)
    assert 0 <= op < self.Last
    self.op = op
    self.stype = stype
    self.v = v
    self.type = type

  def getOpName(self):
    return self.opnames[self.op]

  @staticmethod
  def getOpId(name):
    try:
      return ConversionOp.opids[name]
    except:
      raise ParseError('Unknown conversion instruction')

  @staticmethod
  def enforceIntSrc(op):
    return op == ConversionOp.Trunc or\
           op == ConversionOp.ZExt or\
           op == ConversionOp.SExt or\
           op == ConversionOp.ZExtOrTrunc or\
           op == ConversionOp.Int2Ptr

  @staticmethod
  def enforcePtrSrc(op):
    return op == ConversionOp.Ptr2Int

  @staticmethod
  def enforceIntTgt(op):
    return op == ConversionOp.Trunc or\
           op == ConversionOp.ZExt or\
           op == ConversionOp.SExt or\
           op == ConversionOp.ZExtOrTrunc or\
           op == ConversionOp.Ptr2Int

  @staticmethod
  def enforcePtrTgt(op):
    return op == ConversionOp.Int2Ptr

  def __repr__(self):
    st = str(self.stype)
    if len(st) > 0:
      st = ' ' + st
    tt = str(self.type)
    if len(tt) > 0:
      tt = ' to ' + tt
    return '%s%s %s%s' % (self.getOpName(), st, self.v.getName(), tt)

  def toSMT(self, defined, poison, state, qvars):
    return {
      self.Trunc:       lambda v: Extract(self.type.getSize()-1, 0, v),
      self.ZExt:        lambda v: ZeroExt(self.type.getSize() -
                                         self.stype.getSize(), v),
      self.SExt:        lambda v: SignExt(self.type.getSize() -
                                          self.stype.getSize(), v),
      self.ZExtOrTrunc: lambda v: truncateOrZExt(v, self.type.getSize()),
      self.Ptr2Int:     lambda v: truncateOrZExt(v, self.type.getSize()),
      self.Int2Ptr:     lambda v: truncateOrZExt(v, self.type.getSize()),
      self.Bitcast:     lambda v: v,
    }[self.op](state.eval(self.v, defined, poison, qvars))

  def getTypeConstraints(self, bitwidth):
    cnstr = {
      self.Trunc:       lambda src,tgt: src > tgt,
      self.ZExt:        lambda src,tgt: src < tgt,
      self.SExt:        lambda src,tgt: src < tgt,
      self.ZExtOrTrunc: lambda src,tgt: BoolVal(True),
      self.Ptr2Int:     lambda src,tgt: BoolVal(True),
      self.Int2Ptr:     lambda src,tgt: BoolVal(True),
      self.Bitcast:     lambda src,tgt: src.getSize() == tgt.getSize(),
    } [self.op](self.stype, self.type)

    return And(self.stype == self.v.type,
               self.type.getTypeConstraints(bitwidth),
               self.stype.getTypeConstraints(bitwidth),
               cnstr)

  matcher = {
    Trunc:   'm_Trunc',
    ZExt:    'm_ZExt',
    SExt:    'm_SExt',
    Ptr2Int: 'm_PtrToInt',
    Bitcast: 'm_BitCast',
  }


  constr = {
    Trunc:   'TruncInst',
    ZExt:    'ZExtInst',
    SExt:    'SExtInst',
    Ptr2Int: 'PtrToIntInst',
    Int2Ptr: 'IntToPtrInst',
    Bitcast: 'BitCastInst',
  }

  def register_types(self, manager):
    if self.enforceIntSrc(self.op):
      manager.register_type(self.v, self.stype, IntType())
    elif self.enforcePtrSrc(self.op):
      manager.register_type(self.v, self.stype, PtrType())
    else:
      manager.register_type(self.v, self.stype, UnknownType())

    if self.enforceIntTgt(self.op):
      manager.register_type(self, self.type, IntType())
    elif self.enforcePtrTgt(self.op):
      manager.register_type(self, self.type, PtrType())
    else:
      manager.register_type(self, self.type, UnknownType())
    # TODO: inequalities for trunc/sext/zext

  def visit_source(self, mb):
    r = mb.subpattern(self.v)

    if self.op == ConversionOp.ZExtOrTrunc:
      return CFunctionCall('match',
        mb.get_my_ref(),
        CFunctionCall('m_CombineOr',
          CFunctionCall('m_ZExt', r),
          CFunctionCall('m_ZTrunc', r)))

    return mb.simple_match(ConversionOp.matcher[self.op], r)

  def visit_target(self, manager, use_builder=False):
    if self.op == ConversionOp.ZExtOrTrunc:
      assert use_builder  #TODO: handle ZExtOrTrunk in root position
      instr = CVariable('Builder').arr('CreateZExtOrTrunc',
        [manager.get_cexp(self.v), manager.get_llvm_type(self)])
      return [CDefinition.init(
        manager.PtrValue,
        manager.get_cexp(self),
        instr)]

    else:
      instr = CFunctionCall('new ' + ConversionOp.constr[self.op],
        manager.get_cexp(self.v), manager.get_llvm_type(self))

      if use_builder:
        instr = CVariable('Builder').arr('Insert', [instr])

    return [CDefinition.init(
      manager.PtrInstruction,
      manager.get_cexp(self),
      instr)]


################################
class Icmp(Instr):
  EQ, NE, UGT, UGE, ULT, ULE, SGT, SGE, SLT, SLE, Var, Last = range(12)

  opnames = {
    EQ:  'eq',
    NE:  'ne',
    UGT: 'ugt',
    UGE: 'uge',
    ULT: 'ult',
    ULE: 'ule',
    SGT: 'sgt',
    SGE: 'sge',
    SLT: 'slt',
    SLE: 'sle',
  }
  opids = {v:k for k, v in opnames.items()}


  def __init__(self, op, type, v1, v2):
    assert isinstance(type, Type)
    assert isinstance(v1, Value)
    assert isinstance(v2, Value)
    self.op = self.getOpId(op)
    if self.op == self.Var:
      self.opname = op
    self.type = IntType(1)
    self.stype = type.ensureIntPtrOrVector()
    self.v1 = v1
    self.v2 = v2

  def getOpName(self):
    return 'icmp'

  @staticmethod
  def getOpId(name):
    return Icmp.opids.get(name, Icmp.Var)

  def __repr__(self):
    op = self.opname if self.op == Icmp.Var else Icmp.opnames[self.op]
    if len(op) > 0:
      op = ' ' + op
    t = str(self.stype)
    if len(t) > 0:
      t = ' ' + t
    return 'icmp%s%s %s, %s' % (op, t, self.v1.getName(), self.v2.getName())

  def opToSMT(self, op, a, b):
    return {
      self.EQ:  lambda a,b: toBV(a == b),
      self.NE:  lambda a,b: toBV(a != b),
      self.UGT: lambda a,b: toBV(UGT(a, b)),
      self.UGE: lambda a,b: toBV(UGE(a, b)),
      self.ULT: lambda a,b: toBV(ULT(a, b)),
      self.ULE: lambda a,b: toBV(ULE(a, b)),
      self.SGT: lambda a,b: toBV(a > b),
      self.SGE: lambda a,b: toBV(a >= b),
      self.SLT: lambda a,b: toBV(a < b),
      self.SLE: lambda a,b: toBV(a <= b),
    }[op](a, b)

  def recurseSMT(self, ops, a, b, i):
    if len(ops) == 1:
      return self.opToSMT(ops[0], a, b)
    opname = self.opname if self.opname != '' else self.getName()
    var = BitVec('icmp_' + opname, 4)
    assert 1 << 4 > self.Var
    return If(var == i,
              self.opToSMT(ops[0], a, b),
              self.recurseSMT(ops[1:], a, b, i+1))

  def toSMT(self, defined, poison, state, qvars):
    # Generate all possible comparisons if icmp is generic. Set of comparisons
    # can be restricted in the precondition.
    ops = [self.op] if self.op != self.Var else range(self.Var)
    return self.recurseSMT(ops, state.eval(self.v1, defined, poison, qvars),
                           state.eval(self.v2, defined, poison, qvars), 0)

  def getTypeConstraints(self, bitwidth):
    return And(self.stype == self.v1.type,
               self.stype == self.v2.type,
               self.type.getTypeConstraints(bitwidth),
               self.stype.getTypeConstraints(bitwidth))

  op_enum = {
    EQ:  'ICmpInst::ICMP_EQ',
    NE:  'ICmpInst::ICMP_NE',
    UGT: 'ICmpInst::ICMP_UGT',
    UGE: 'ICmpInst::ICMP_UGE',
    ULT: 'ICmpInst::ICMP_ULT',
    ULE: 'ICmpInst::ICMP_ULE',
    SGT: 'ICmpInst::ICMP_SGT',
    SGE: 'ICmpInst::ICMP_SGE',
    SLT: 'ICmpInst::ICMP_SLT',
    SLE: 'ICmpInst::ICMP_SLE',
  }

  def register_types(self, manager):
    manager.register_type(self, self.type, IntType(1))
    manager.register_type(self.v1, self.stype, UnknownType().ensureIntPtrOrVector())
    manager.unify(self.v1, self.v2)

  PredType = CTypeName('CmpInst::Predicate')

  def visit_source(self, mb):
    r1 = mb.subpattern(self.v1)
    r2 = mb.subpattern(self.v2)

    if self.op == Icmp.Var:
      opname = self.opname if self.opname else 'Pred ' + self.name
      name = mb.manager.get_key_name(opname)  #FIXME: call via mb?
      rp = mb.binding(name, self.PredType)

      return mb.simple_match('m_ICmp', rp, r1, r2)

    pvar = mb.new_name('P')
    rp = mb.binding(pvar, self.PredType)

    return CBinExpr('&&',
      mb.simple_match('m_ICmp', rp, r1, r2),
      CBinExpr('==', CVariable(pvar), CVariable(Icmp.op_enum[self.op])))

  def visit_target(self, manager, use_builder=False):

    # determine the predicate
    if self.op == Icmp.Var:
      key = self.opname if self.opname else 'Pred ' + self.name
      opname = manager.get_key_name(key)
      assert manager.bound(opname)
      # TODO: confirm type

    else:
      opname = Icmp.op_enum[self.op]

    instr = CFunctionCall('new ICmpInst', CVariable(opname),
      manager.get_cexp(self.v1),
      manager.get_cexp(self.v2))

    if use_builder:
      instr = CVariable('Builder').arr('Insert', [instr])

    return [
      CDefinition.init(manager.PtrInstruction, manager.get_cexp(self), instr)]


################################
class Select(Instr):
  def __init__(self, type, c, v1, v2):
    assert isinstance(type, Type)
    assert isinstance(c, Value)
    assert isinstance(c.type, IntType)
    assert isinstance(v1, Value)
    assert isinstance(v2, Value)
    self.type = type.ensureFirstClass()
    self.c = c
    self.v1 = v1
    self.v2 = v2

  def __repr__(self):
    t = str(self.type)
    if len(t) > 0:
      t = t + ' '
    return 'select i1 %s, %s%s, %s%s' % (self.c.getName(), t, self.v1.getName(),
                                         t, self.v2.getName())

  def getOpName(self):
    return 'select'

  def toSMT(self, defined, poison, state, qvars):
    return If(state.eval(self.c, defined, poison, qvars) == 1,
              state.eval(self.v1, defined, poison, qvars),
              state.eval(self.v2, defined, poison, qvars))

  def getTypeConstraints(self, bitwidth):
    return And(self.type == self.v1.type,
               self.type == self.v2.type,
               self.c.type == 1,
               self.type.getTypeConstraints(bitwidth))

  def register_types(self, manager):
    manager.register_type(self, self.type, UnknownType().ensureFirstClass())
    manager.register_type(self.c, self.c.type, IntType(1))
    manager.unify(self, self.v1, self.v2)

  def visit_source(self, mb):
    c = mb.subpattern(self.c)
    v1 = mb.subpattern(self.v1)
    v2 = mb.subpattern(self.v2)

    return mb.simple_match('m_Select', c, v1, v2)

  def visit_target(self, manager, use_builder=False):
    instr = CFunctionCall('SelectInst::Create',
      manager.get_cexp(self.c),
      manager.get_cexp(self.v1),
      manager.get_cexp(self.v2))

    if use_builder:
      instr = CVariable('Builder').arr('Insert', [instr])

    return [CDefinition.init(manager.PtrInstruction, manager.get_cexp(self), instr)]

################################
class Alloca(Instr):
  def __init__(self, type, elemsType, numElems, align):
    assert isinstance(elemsType, IntType)
    assert isinstance(align, int)
    self.type = PtrType(type)
    self.elemsType = elemsType
    self.numElems = TypeFixedValue(numElems, 1, 16)
    self.align = align

  def __repr__(self):
    elems = self.numElems.getName()
    if elems == '1':
      elems = ''
    else:
      t = str(self.elemsType)
      if len(t) > 0:
        t += ' '
      elems =  ', ' + t + elems
    align = ', align %d' % self.align if self.align != 0 else ''
    return 'alloca %s%s%s' % (str(self.type.type), elems, align)

  def getOpName(self):
    return 'alloca'

  def toSMT(self, defined, poison, state, qvars):
    self.numElems.toSMT(defined, poison, state, qvars)
    ptr = BitVec(self.getName(), self.type.getSize())
    block_size = getAllocSize(self.type.type)
    num_elems = self.numElems.getValue()
    size = num_elems * block_size

    if size == 0:
      qvars.append(ptr)
      return ptr

    if size > 8:
      defined.append(ULT(ptr, ptr + ((size >> 3) - 1)))
    defined += [ptr != 0,
                getPtrAlignCnstr(ptr, self.align)]

    mem = freshBV('alloca' + self.getName(), size)
    state.addAlloca(ptr, mem, block_size, num_elems, self.align)

    for i in range(0, size/8):
      idx = 8*i
      state.store([], ptr + i, Extract(idx+7, idx, mem))
    return ptr

  def getTypeConstraints(self, bitwidth):
    return And(self.numElems.getType() == self.elemsType,
               self.type.getTypeConstraints(bitwidth),
               self.elemsType.getTypeConstraints(bitwidth),
               self.numElems.getTypeConstraints(bitwidth))


################################
class GEP(Instr):
  def __init__(self, type, ptr, idxs, inbounds):
    assert isinstance(type, PtrType)
    assert isinstance(ptr, Value)
    assert isinstance(idxs, list)
    assert isinstance(inbounds, bool)
    for i in range(len(idxs)):
      assert isinstance(idxs[i], IntType if (i & 1) == 0 else Value)
    self.type = type
    self.ptr = ptr
    self.idxs = idxs[1:len(idxs):2]
    self.inbounds = inbounds

  def __repr__(self):
    inb = 'inbounds ' if self.inbounds else ''
    idxs = ''
    for i in range(len(self.idxs)):
      t = str(self.idxs[i].type)
      if len(t) > 0:
        t += ' '
      idxs += ', %s%s' % (t, self.idxs[i].getName())
    return 'getelementptr %s%s %s%s' % (inb, self.type, self.ptr.getName(),
                                        idxs)

  def getOpName(self):
    return 'getelementptr'

  def toSMT(self, defined, poison, state, qvars):
    ptr = state.eval(self.ptr, defined, poison, qvars)
    type = self.type
    for i in range(len(self.idxs)):
      idx = truncateOrSExt(state.eval(self.idxs[i], defined, poison, qvars),ptr)
      ptr += getAllocSize(type.getPointeeType())/8 * idx
      if i + 1 != len(self.idxs):
        type = type.getUnderlyingType()

    # TODO: handle inbounds
    return ptr

  def getTypeConstraints(self, bitwidth):
    return And(self.type.ensureTypeDepth(len(self.idxs)),
               Instr.getTypeConstraints(self, bitwidth))


################################
class Load(Instr):
  def __init__(self, stype, v, align):
    assert isinstance(stype, PtrType)
    assert isinstance(v, Value)
    assert isinstance(align, int)
    self.stype = stype
    stype.type = stype.type.ensureFirstClass()
    self.type = stype.type
    self.v = v
    self.align = align

  def __repr__(self):
    align = ', align %d' % self.align if self.align != 0 else ''
    return 'load %s %s%s' % (str(self.stype), self.v.getName(), align)

  def getOpName(self):
    return 'load'

  def toSMT(self, defined, poison, state, qvars):
    qvars += state.mem_qvars
    ptr = state.eval(self.v, defined, poison, qvars)
    access_sz = getAllocSize(self.type)
    defined_align_access(state, defined, access_sz, self.align, ptr)

    bytes = []
    sz = self.type.getSize()
    rem = sz % 8
    if rem != 0:
      sz = sz - rem
      bytes = [Extract(rem-1, 0, state.load(ptr))]
      ptr += 1
    for i in range(0, sz/8):
      # FIXME: assumes little-endian
      bytes = [state.load(ptr + i)] + bytes
    return mk_concat(bytes)

  def getTypeConstraints(self, bitwidth):
    return And(self.stype == self.v.type,
               self.type == self.v.type.getPointeeType(),
               self.type.getTypeConstraints(bitwidth))


################################
class Store(Instr):
  def __init__(self, stype, src, type, dst, align):
    assert isinstance(stype, Type)
    assert isinstance(src, Value)
    assert isinstance(type, PtrType)
    assert isinstance(dst, Value)
    assert isinstance(align, int)
    self.stype = stype.ensureFirstClass()
    self.src = src
    self.type = type
    self.dst = dst
    self.align = align
    self.setName('store')
    self.id = mk_unique_id()
    self.type.setName(self.getUniqueName())

  def getUniqueName(self):
    return self.getName() + '_' + self.id

  def getOpName(self):
    return 'store'

  def __repr__(self):
    t = str(self.stype)
    if len(t) > 0:
      t = t + ' '
    align = ', align %d' % self.align if self.align != 0 else ''
    return 'store %s%s, %s %s%s' % (t, self.src.getName(), str(self.type),
                                    self.dst.getName(), align)

  def toSMT(self, defined, poison, state, qvars):
    qvars_new = []
    src = state.eval(self.src, defined, poison, qvars_new)
    tgt = state.eval(self.dst, defined, poison, qvars_new)
    qvars += qvars_new
    state.mem_qvars += qvars_new

    src_size = self.stype.getSize()
    write_size = getAllocSize(self.stype)
    defined_align_access(state, defined, write_size, self.align, tgt)

    src_idx = 0
    # FIXME: assumes little-endian
    if src_size != write_size:
      rem = src_size % 8
      rest = Extract(rem-1, 0, src)
      rest_old = Extract(7, rem, state.load(tgt))
      state.store(state.defined, tgt, Concat(rest_old, rest))
      tgt += 1
      write_size -= 8
      assert (src_size-rem) == write_size
      src_idx = rem
    for i in range(0, write_size/8):
      state.store(state.defined, tgt+i, Extract(src_idx+7, src_idx, src))
      src_idx += 8
    return None

  def getTypeConstraints(self, bitwidth):
    return And(self.stype == self.type.type,
               self.src.type == self.stype,
               self.dst.type == self.type,
               self.stype.getTypeConstraints(bitwidth),
               self.type.getTypeConstraints(bitwidth))


################################
class Skip(Instr):
  def __init__(self):
    self.id = mk_unique_id()

  def getUniqueName(self):
    return 'skip_' + self.id

  def __repr__(self):
    return 'skip'

  def toSMT(self, defined, poison, state, qvars):
    return None


################################
class Unreachable(Instr):
  def __init__(self):
    self.id = mk_unique_id()

  def getUniqueName(self):
    return 'unreachable_' + self.id

  def __repr__(self):
    return 'unreachable'

  def toSMT(self, defined, poison, state, qvars):
    defined.append(BoolVal(False))
    return None


################################
class TerminatorInst(Instr):
  pass


################################
class Br(TerminatorInst):
  def __init__(self, bb_label, cond, true, false):
    assert isinstance(bb_label, str)
    assert isinstance(cond, Value)
    assert isinstance(true, str)
    assert isinstance(false, str)
    self.cond = cond
    self.true = true
    self.false = false
    self.setName('br_' + bb_label)

  def __repr__(self):
    return "br i1 %s, label %s, label %s" % (self.cond.getName(),
                                             self.true, self.false)

  def getSuccessors(self, state):
    defined = []
    poison = []
    qvars = []
    cond = state.eval(self.cond, defined, poison, qvars)
    assert qvars == []
    return [(self.true, mk_and([cond != 0] + defined + poison)),
            (self.false, mk_and([cond == 0] + defined + poison))]

  def toSMT(self, defined, poison, state, qvars):
    return None


################################
class Ret(TerminatorInst):
  def __init__(self, bb_label, type, val):
    assert isinstance(bb_label, str)
    assert isinstance(type, Type)
    assert isinstance(val, Value)
    self.type = type
    self.val = val
    self.setName('ret_' + bb_label)

  def __repr__(self):
    t = str(self.type)
    if len(t) > 0:
      t = t + ' '
    return "ret %s%s" % (t, self.val.getName())

  def getSuccessors(self, state):
    return []

  def toSMT(self, defined, poison, state, qvars):
    return state.eval(self.val, defined, poison, qvars)

  def getTypeConstraints(self, bitwidth):
    return And(self.type == self.val.type, self.type.getTypeConstraints(bitwidth))


################################
def print_prog(p, skip):
  for bb, instrs in p.iteritems():
    if bb != "":
      print "%s:" % bb

    for k,v in instrs.iteritems():
      if k in skip:
        continue
      k = str(k)
      if k[0] == '%':
        print '  %s = %s' % (k, v)
      else:
        print "  %s" % v

def to_str_prog(p, skip):
  out = ""
  for bb, instrs in p.iteritems():
    if bb != "":
      out += "%s:\n" % bb

    for k,v in instrs.iteritems():
      if k in skip:
        continue
      k = str(k)
      if k[0] == '%':
        out += '  %s = %s\n' % (k, v)
      else:
        out += "  %s\n" % v
  return out

class LVar:
  def __init__(self, v):
    assert isinstance(v, int)
    self.v = v

  def __repr__(self):
    return self.to_lean_str()

  def to_lean_str(self):
    return "%v" + str(self.v)

  
class LExpr:
  def to_lean_str(self):
    raise RuntimeError("to_lean_str not implemented")
  pass


class LExprUnit(LExpr):
  def __init__(self): pass
  def __str__(self): return self.to_lean_str()
  def to_lean_str(self): return "unit: "

class LExprPair(LExpr):
  def __init__(self, v1, v2):
    assert isinstance(v1, LVar)
    assert isinstance(v2, LVar)
    self.v1 = v1
    self.v2 = v2

  def __repr__(self):
    return self.to_lean_str()

  def to_lean_str(self):
    return "pair:" + self.v1.to_lean_str() + " " + self.v2.to_lean_str()

class LExprTriple(LExpr):
  def __init__(self, v1, v2, v3):
    assert isinstance(v1, LVar)
    assert isinstance(v2, LVar)
    assert isinstance(v3, LVar)
    self.v1 = v1
    self.v2 = v2
    self.v3 = v3

  def __repr__(self):
    return self.to_lean_str()

  def to_lean_str(self):
    return "triple:" + \
            self.v1.to_lean_str() + " " + \
            self.v2.to_lean_str() + " " + \
            self.v3.to_lean_str()

class LExprOp(LExpr):
  def __init__(self, op, v):
    assert isinstance(op, str)
    assert isinstance(v, LVar)
    self.op = op
    self.v = v
  def __repr__(self):
    return "op:" + self.op + " " + self.v.to_lean_str()

  def to_lean_str(self):
    return str(self)

class ToLeanState:
  def unit_index(self):
    return LVar(9999)

  def __init__(self):
    self.assigns = []
    self.constant_names = []
    self.varmap = {}
    self.nvars = 0 # number of variables so far
    pass

  def new_var(self): # return a new variable name
    self.nvars += 1
    return LVar(self.nvars)  
  
  def add_var_mapping(self, var, lvar):
    assert isinstance(var, str)
    assert isinstance(lvar, LVar)
    print "dbg> adding mapping '%s' -> '%s'" % (var, lvar)
    self.varmap[var] = lvar

  def add_constant_name(self, name):
    assert isinstance(name, str)
    self.constant_names.append(name)
  
  def _append_assign(self, lhs, rhs):
    assert isinstance(lhs, LVar)
    assert isinstance(rhs, LExpr)
    self.assigns.append((lhs, rhs))

  def build_assign(self, rhs):
    v = self.new_var()
    self._append_assign(v, rhs)
    return v
  
  def build_pair(self, v1, v2):
    v = self.new_var()
    self._append_assign(v, LExprPair(v1, v2))
    return v
    
  def build_triple(self, v1, v2, v3):
    v = self.new_var()
    self._append_assign(v, LExprTriple(v1, v2, v3))
    return v

  def find_var_or_throw(self, v):
    print "dbg> find_var_or_throw '%s'" % (v, ),
    if v in self.varmap:
      print(" -> self.varmap[v]")
      return self.varmap[v]
    else:
      raise RuntimeError("unknown variable '%s'" % (v, ))

  def find_var_or_none(self, v):
    print "dbg> find_var_or_none '%s'" % (v, ),
    if v in self.varmap:
      print(" -> self.varmap[v] : %s" % (self.varmap[v]))
      return self.varmap[v]
    else:
      print(" -> None")
      return None

def to_bitwidth(obj):
    t = str(obj.type)
    if len(t) > 0 and t[0] == 'i':
      return int(t[1:])
    else:
      return 'w'

def to_lean_unary_cst_value(val, state):
  assert isinstance(val, CnstUnaryOp)
  assert isinstance(state, ToLeanState)
  if val.op == CnstUnaryOp.Not:
    return state.build_assign(LExprOp("not " + to_bitwidth(val), to_lean_value(val.v, state)))
  elif val.op == CnstUnaryOp.Neg:
    return state.build_assign(LExprOp("neg " + to_bitwidth(val), to_lean_value(val.v, state)))
  else:
    raise RuntimeError("unknown unary constant '%s'" % (val.op, ))


def to_lean_binary_cst_value(val, state):
  assert isinstance(val, CnstBinaryOp)
  assert isinstance(state, ToLeanState)

  v1 = to_lean_value(val.v1, state)
  v2 = to_lean_value(val.v2, state)

  # And, Or, Xor, Add, Sub, Mul, Div, DivU, Rem, RemU, AShr, LShr, Shl,\
  mapping = {
    CnstBinaryOp.And : "and",
    CnstBinaryOp.Or  : "or",
    CnstBinaryOp.Xor : "xor",
    CnstBinaryOp.Add : "add",
    CnstBinaryOp.Sub : "sub",
    CnstBinaryOp.Mul : "mul",
    CnstBinaryOp.Div : "div",
    CnstBinaryOp.DivU : "divu",
    CnstBinaryOp.RemU : "remu",
    CnstBinaryOp.AShr : "ashr",
    CnstBinaryOp.LShr : "lhsr",
    CnstBinaryOp.Shl : "shl",
  }

  opname = None
  if val.op in mapping:
    opname = mapping[val.op] + " " + to_bitwidth(val)
  else:
      raise RuntimeError("unknown binary constant '%s', op index: '%s'" % (val, val.op, ))
  largs = state.build_pair(v1, v2)
  return state.build_assign(LExprOp(opname, largs))

def to_lean_value(val, state):
  assert isinstance(val, Value)
  assert isinstance(state, ToLeanState)
  print("dbg> to_lean_value (%s) type(%s)" % (val, val.__class__))
    # TODO: maybe treat consants differently?
  if isinstance(val, CnstUnaryOp):
    return to_lean_unary_cst_value(val, state)
  if isinstance(val, CnstBinaryOp):
    return to_lean_binary_cst_value(val, state)
  if isinstance(val, ConstantVal):
    bitwidth = to_bitwidth(val)
    lrhs = LExprOp("const (Bitvec.ofInt' " + str(bitwidth) + " (%s))" % val.getName(), state.unit_index())
    lval = state.build_assign(lrhs)
    state.add_var_mapping(val.name, lval)
    return lval
  elif isinstance(val, Input):
    lval = state.find_var_or_none(val.name)
    if lval is not None:
      return lval  
    cleaned_up_name = val.name.replace("%", "")
    lrhs = LExprOp("const (Bitvec.ofInt' " + str(to_bitwidth(val)) + " (%s))" % cleaned_up_name, state.unit_index())
    lval = state.build_assign(lrhs)
    state.add_var_mapping(val.name, lval)
    # TODO: think if this can be unified with ConstantVal
    state.add_constant_name(cleaned_up_name) # add a new constant to be generated in the def.
    return lval
  elif isinstance(val, Instr):
    return state.find_var_or_throw(val.getName())
  raise RuntimeError("cannot convert value '%s' (type: '%s')" % (val, val.__class__))

def to_lean_binop(bop, state):
  print("dbg> to_lean_binop(%s) type(%s)" % (bop, bop.__class__))
  out = ""
  lv1 = to_lean_value(bop.v1, state)
  lv2 = to_lean_value(bop.v2, state)
  pair = state.build_pair(lv1, lv2)
  bitwidth = to_bitwidth(bop)
  #   And, Or, Xor, Add, Sub, Mul, Div, DivU, Rem, RemU, AShr, LShr, Shl,\
  if bop.op == BinOp.Add: return LExprOp("add " + str(bitwidth), pair)
  if bop.op == BinOp.Sub: return LExprOp("sub " + str(bitwidth), pair)
  if bop.op == BinOp.Mul: return LExprOp("mul " + str(bitwidth), pair)
  if bop.op == BinOp.UDiv: return LExprOp("udiv " + str(bitwidth), pair)
  if bop.op == BinOp.SDiv: return LExprOp("sdiv " + str(bitwidth), pair)
  if bop.op == BinOp.URem: return LExprOp("urem " + str(bitwidth), pair)
  if bop.op == BinOp.SRem: return LExprOp("srem " + str(bitwidth), pair)
  if bop.op == BinOp.Shl: return LExprOp("shl " + str(bitwidth), pair)
  if bop.op == BinOp.AShr: return LExprOp("ashr " + str(bitwidth), pair)
  if bop.op == BinOp.LShr: return LExprOp("lhsr " + str(bitwidth), pair)
  if bop.op == BinOp.Mul: return LExprOp("mul " + str(bitwidth), pair)
  if bop.op == BinOp.And: return LExprOp("and " + str(bitwidth), pair)
  if bop.op == BinOp.Or: return LExprOp("or " + str(bitwidth), pair)
  if bop.op == BinOp.Xor: return LExprOp("xor " + str(bitwidth), pair)
  else:
    raise RuntimeError("unknown binop '%s' ; bop.op = '%s'" % (bop, bop.op)) 

def to_lean_select(instr, state):
  print("dbg> to_lean_state(%s) type(%s)" % (instr, instr.__class__))
  assert isinstance(instr, Select)
  assert isinstance(state, ToLeanState)
  lcond = to_lean_value(instr.c, state)
  lv1 = to_lean_value(instr.v1, state)
  lv2 = to_lean_value(instr.v2, state)
  triple = state.build_triple(lcond, lv1, lv2)
  return LExprOp("select", triple)

def to_lean_conversion_op(instr, state):
  assert isinstance(instr, ConversionOp)
  # TODO: how does on e handle different bit widths?
  print("dbg> to_lean_binop(%s) type(%s)" % (instr, instr.__class__))
  out = ""
  lv1 = to_lean_value(instr.v, state)
  type_src = instr.stype
  type_tgt = instr.type
  raise RuntimeError("unknown conversion op '%s' ; conversionop.op = '%s'" % (instr, ConversionOp.opnames[instr.op])) 

def to_lean_icmp(instr, state):
  assert isinstance(instr, Icmp)
  opname = "%s "  % (Icmp.opnames[instr.op], ) + str(to_bitwidth(instr))
  lv1 = to_lean_value(instr.v1, state)
  lv2 = to_lean_value(instr.v2, state)
  pair = state.build_pair(lv1, lv2)
  return LExprOp(opname, pair)

def to_lean_instr(instr, state):
  print("dbg> to_lean_instr(%s) type(%s)" % (instr, instr.__class__))
  if isinstance(instr, BinOp):
    return to_lean_binop(instr, state)
  elif isinstance(instr, ConversionOp):
    return to_lean_conversion_op(instr, state)
  elif isinstance(instr, Select):
    return to_lean_select(instr, state)
  elif isinstance(instr, Icmp):
    return to_lean_icmp(instr, state)
  elif isinstance(instr, CopyOperand):
    var = to_lean_value(instr.v, state)
    return LExprOp("copy", var) # copy variable into this value.
  else:
    raise RuntimeError("unknown instruction '%s' (type: '%s')" % (instr, instr.__class__))
  
    
def to_lean_prog(p, num_indent=2, skip=[]):
  state = ToLeanState()
  out = ""
  out += " "*num_indent + "^bb"
  
  # create a single unit that is reused everywhere.
  state._append_assign(state.unit_index(), LExprUnit()) 
  for bb, instrs in p.iteritems():
    if bb != "":
      raise RuntimeError("expected no basic block name, got '%s'" % (bb, ))

    for k,v in instrs.iteritems():
      if k in skip:
        continue
      # print("dbg> type of k(%s) : '%s', of v(%s) : '%s'" % (k, type(k), v, v.__class__))
      print("dbg> k:%s := v:%s" % (k, v))
      lrhs = to_lean_instr(v, state) # l for lean
      kstr = str(k)
      if kstr[0] == '%':
        llhs = state.build_assign(lrhs)
        state.add_var_mapping(k, llhs)
      else:
        raise RuntimeError("unknown instruction with side effect: '%s'" % ((k, v)))
  last_var = None
  for (i, (lhs, rhs)) in enumerate(state.assigns):
    assert isinstance(lhs, LVar)
    assert isinstance(rhs, LExpr)
    out += "\n" + " " * num_indent + lhs.to_lean_str() + " := " + rhs.to_lean_str()
    if i + 1 < len(state.assigns):
      out += ";" # we have more, so print a ;

    last_var = lhs
  assert last_var is not None
  assert isinstance(last_var, LVar)
  out += "\n" + " " * num_indent + "dsl_ret " + lhs.to_lean_str()
  # what value do we 'ret'?
  # looks like we 'ret' the last value.
  return (out, state)

def countUsers(prog):
  m = {}
  for bb, instrs in prog.iteritems():
    for k, v in instrs.iteritems():
      v.countUsers(m)
  return m


def getTypeConstraints(p, bitwidth):
  t = [v.getTypeConstraints(bitwidth) for v in p.itervalues()]
  # ensure all return instructions have the same type
  ret_types = [v.type for v in p.itervalues() if isinstance(v, Ret)]
  if len(ret_types) > 1:
    t += mkTyEqual(ret_types)
  return t


def fixupTypes(p, types):
  for v in p.itervalues():
    v.fixupTypes(types)


def toSMT(prog, idents, isSource):
  set_smt_is_source(isSource)
  state = State()
  for k,v in idents.iteritems():
    if isinstance(v, (Input, Constant)):
      defined = []
      poison = []
      qvars = []
      smt = v.toSMT(defined, poison, state, qvars)
      assert defined == [] and poison == []
      state.add(v, smt, [], [], qvars)

  for bb, instrs in prog.iteritems():
    state.newBB(bb)
    for k,v in instrs.iteritems():
      defined = []
      poison = []
      qvars = []
      smt = v.toSMT(defined, poison, state, qvars)
      state.add(v, smt, defined, poison, qvars)
  return state
