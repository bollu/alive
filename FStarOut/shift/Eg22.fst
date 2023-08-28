module Eg22

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



(* Name:InstCombineShift: 458 *)
(* precondition: true *)
(*
 let %s = ashr i31 %X, C in 
 let %Op0 = sub %s, %Y in 
 let %r = shl %Op0, C in 

=>
 let %s2 = shl %Y, C in 
 let %a = sub %X, %s2 in 
 let %s = ashr i31 %X, C in 
 let %Op0 = sub %s, %Y in 
 let %r = and %a, (-1 << C) in 

*)
let alive_InstCombineShift__458 (input_c input_x input_y : BV.bv_t 31)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_c) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_ashr 31 var_3 in
  let var_5 = op_const (input_y) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_sub 31 var_6 in
  let var_8 = (var_7, var_2) in
  let var_9 = op_shl 31 var_8 in
  (* return_value *) var_9) == (
  let var_0 = () in
  let var_1 = op_const (input_y) var_0 in
  let var_2 = op_const (input_c) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_shl 31 var_3 in
  let var_5 = op_const (input_x) var_0 in
  let var_6 = (var_5, var_4) in
  let var_7 = op_sub 31 var_6 in
  let var_8 = (var_5, var_2) in
  let var_9 = op_ashr 31 var_8 in
  let var_10 = (var_9, var_1) in
  let var_11 = op_sub 31 var_10 in
  let var_12 = op_const (BV.int2bv -1) var_0 in
  let var_13 = (var_12, var_2) in
  let var_14 = op_shl 31 var_13 in
  let var_15 = (var_7, var_14) in
  let var_16 = op_and 31 var_15 in
  (* return_value *) var_16))
 = ()