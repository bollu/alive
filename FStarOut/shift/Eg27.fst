module Eg27

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



(* Name:InstCombineShift: 497''' *)
(* precondition: true *)
(*
 let %Op0 = add %X, C2 in 
 let %r = shl %Op0, C in 

=>
 let %s2 = shl %X, C in 
 let %Op0 = add %X, C2 in 
 let %r = add %s2, (C2 << C) in 

*)
let alive_InstCombineShift__497''' (w : pos) (input_c2 input_c input_x : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_c2) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_add w var_3 in
  let var_5 = op_const (input_c) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_shl w var_6 in
  (* return_value *) var_7) == (
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_c) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_shl w var_3 in
  let var_5 = op_const (input_c2) var_0 in
  let var_6 = (var_1, var_5) in
  let var_7 = op_add w var_6 in
  let var_8 = (var_5, var_2) in
  let var_9 = op_shl w var_8 in
  let var_10 = (var_4, var_9) in
  let var_11 = op_add w var_10 in
  (* return_value *) var_11))
 = ()