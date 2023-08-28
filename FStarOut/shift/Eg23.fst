module Eg23

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



(* Name:InstCombineShift: 476 *)
(* precondition: true *)
(*
 let %shr = lshr %X, C in 
 let %s = and %shr, C2 in 
 let %Op0 = or %s, %Y in 
 let %r = shl %Op0, C in 

=>
 let %s2 = shl %Y, C in 
 let %a = and %X, (C2 << C) in 
 let %shr = lshr %X, C in 
 let %s = and %shr, C2 in 
 let %Op0 = or %s, %Y in 
 let %r = or %a, %s2 in 

*)
let alive_InstCombineShift__476 (w : pos) (input_c2 input_c input_x input_y : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_c) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_lshr w var_3 in
  let var_5 = op_const (input_c2) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_and w var_6 in
  let var_8 = op_const (input_y) var_0 in
  let var_9 = (var_7, var_8) in
  let var_10 = op_or w var_9 in
  let var_11 = (var_10, var_2) in
  let var_12 = op_shl w var_11 in
  (* return_value *) var_12) == (
  let var_0 = () in
  let var_1 = op_const (input_y) var_0 in
  let var_2 = op_const (input_c) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_shl w var_3 in
  let var_5 = op_const (input_x) var_0 in
  let var_6 = op_const (input_c2) var_0 in
  let var_7 = (var_6, var_2) in
  let var_8 = op_shl w var_7 in
  let var_9 = (var_5, var_8) in
  let var_10 = op_and w var_9 in
  let var_11 = (var_5, var_2) in
  let var_12 = op_lshr w var_11 in
  let var_13 = (var_12, var_6) in
  let var_14 = op_and w var_13 in
  let var_15 = (var_14, var_1) in
  let var_16 = op_or w var_15 in
  let var_17 = (var_10, var_4) in
  let var_18 = op_or w var_17 in
  (* return_value *) var_18))
 = ()