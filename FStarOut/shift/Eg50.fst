module Eg50

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



(* Name:InstCombineShift: 724 *)
(* precondition: true *)
(*
 let %Op0 = shl i31 C1, %A in 
 let %r = shl %Op0, C2 in 

=>
 let %Op0 = shl i31 C1, %A in 
 let %r = shl (C1 << C2), %A in 

*)
let alive_InstCombineShift__724 (input_c1 input_c2 input_a : BV.bv_t 31)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_c1) var_0 in
  let var_2 = op_const (input_a) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_shl 31 var_3 in
  let var_5 = op_const (input_c2) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_shl 31 var_6 in
  (* return_value *) var_7) == (
  let var_0 = () in
  let var_1 = op_const (input_c1) var_0 in
  let var_2 = op_const (input_a) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_shl 31 var_3 in
  let var_5 = op_const (input_c2) var_0 in
  let var_6 = (var_1, var_5) in
  let var_7 = op_shl 31 var_6 in
  let var_8 = (var_7, var_2) in
  let var_9 = op_shl 31 var_8 in
  (* return_value *) var_9))
 = ()