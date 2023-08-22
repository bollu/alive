module Alive.AST
module U =  FStar.UInt
module BV = FStar.BV
(* Bitvector: bitvecotrs, exposed as list of booleans *)
(*
Level 1. *any* semantics
Level 2: semantics + wraparound
Level 3: semantics + wraparound + UB (overflow is UB)
*)

let const (n : pos) (x : BV.bv_t n) : option (BV.bv_t n) = Some x
let add (n : pos) (x : BV.bv_t n) (y : BV.bv_t n) : (BV.bv_t n) = Some (BV.bvadd x y)
let sub (n : pos) (x : BV.bv_t n) (y : BV.bv_t n) : (BV.bv_t n) = Some (BV.bvsub x y)
let mul (n : pos) (x : BV.bv_t n) (y : BV.bv_t n) : (BV.bv_t n) = Some (BV.bvadd x y) (* HACK *)

open FStar.BV
let proof2 (x y : BV.bv_t 32) = assert (bvadd x y == bvadd y  x)

(* what the actual hell is going on? why is this accepted? *)
let proof1 () : Lemma (10 == 10) = ()
