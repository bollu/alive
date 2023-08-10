(*
Produces a processed json file from `fst`/`fsti` plus a `queries.jsonl`, where the
`queries.jsonl` has been produced from the raw `smt2` queries that are sent to Z3.
These raw `smt2` queries must have been gathered with an invocation with
  $ export OTHERFLAGS="--z3refresh --log_queries" <build-command-such-as-`make`>.
Authors: Nikhil Swamy, Saikat Chakrabory, Siddharth Bhat
*)
module Alive
open Alive.AST
