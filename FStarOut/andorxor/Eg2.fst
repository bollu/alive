module Eg2

module U = FStar.UInt
module BV = FStar.BV
open FStar.BV


let op_const (#n : pos) (x : BV.bv_t n) (u: unit) : (BV.bv_t n) = x
let op_and (n : pos) (x : BV.bv_t n * BV.bv_t n) : (BV.bv_t n) = bvand (fst x) (snd x)
let op_xor (n : pos) (x : BV.bv_t n * BV.bv_t n) : (BV.bv_t n) = bvxor (fst x) (snd x)
let op_add (n : pos) (x : BV.bv_t n * BV.bv_t n) : (BV.bv_t n) = bvadd (fst x) (snd x)
let op_not (n : pos) (x : BV.bv_t n) :  (BV.bv_t n) = bvnot x
let op_or (n : pos) (x : BV.bv_t n * BV.bv_t n) : (BV.bv_t n) = bvor (fst x) (snd x)
let op_sub (n : pos) (x : BV.bv_t n * BV.bv_t n) : (BV.bv_t n) = bvsub (fst x) (snd x)
let op_shl (n : pos) (x : BV.bv_t n * BV.bv_t n) : (BV.bv_t n) = fst x (* TODO *)
let op_ashr (n : pos) (x : BV.bv_t n * BV.bv_t n) : (BV.bv_t n) = fst x (* TODO *)
let op_lshr (n : pos) (x : BV.bv_t n * BV.bv_t n) : (BV.bv_t n) = fst x (* TODO *)



(* Name:AndOrXor:144 *)
(* precondition: true *)
(*
 let %op = or %X, C1 in 
 let %r = and %op, C2 in 

=>
 let %o = or %X, (C1 & C2) in 
 let %op = or %X, C1 in 
 let %r = and %o, C2 in 

*)
let alive_AndOrXor_144 (w : pos) (input_c2 input_x input_c1 : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_c1) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_or w var_3 in
  let var_5 = op_const (input_c2) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_and w var_6 in
  (* return_value *) var_7) == (
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_c1) var_0 in
  let var_3 = op_const (input_c2) var_0 in
  let var_4 = (var_2, var_3) in
  let var_5 = op_and w var_4 in
  let var_6 = (var_1, var_5) in
  let var_7 = op_or w var_6 in
  let var_8 = (var_1, var_2) in
  let var_9 = op_or w var_8 in
  let var_10 = (var_7, var_3) in
  let var_11 = op_and w var_10 in
  (* return_value *) var_11))
 = ()