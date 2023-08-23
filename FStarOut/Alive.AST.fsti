module Alive.AST
module U =  FStar.UInt
module BV = FStar.BV
(* Bitvector: bitvecotrs, exposed as list of booleans *)
(*
Level 1. *any* semantics
Level 2: semantics + wraparound
Level 3: semantics + wraparound + UB (overflow is UB)
*)


let op_const (#n : pos) (x : BV.bv_t n) (u: unit) :  (BV.bv_t n) = x
let op_and (n : pos) (x : BV.bv_t n * BV.bv_t n) :  (BV.bv_t n) = fst x
let op_xor (n : pos) (x : BV.bv_t n * BV.bv_t n) :  (BV.bv_t n) = fst x
let op_add (n : pos) (x : BV.bv_t n * BV.bv_t n) :  (BV.bv_t n) = fst x
let op_not (n : pos) (x : BV.bv_t n) :  (BV.bv_t n) = x
let op_or (n : pos) (x : BV.bv_t n * BV.bv_t n) :  (BV.bv_t n) = fst x
let op_sub (n : pos) (x : BV.bv_t n * BV.bv_t n) :  (BV.bv_t n) = fst x


let x : BV.bv_t 3 = op_const #3 (BV.int2bv 7) ()

open FStar.BV
let proof2 (x y : BV.bv_t 32) = assert (bvadd x y == bvadd y  x)

let proof3 (x y : BV.bv_t 32) = assert ((let x = 1 in x) = (let x = 1 in x))




(* what the actual hell is going on? why is this accepted? *)
let proof1 () : Lemma (10 == 10) = ()
