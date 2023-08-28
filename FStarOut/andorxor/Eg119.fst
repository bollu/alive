module Eg119

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



(* Name:AndOrXor:2063  (X ^ C1) | C2 --> (X | C2) ^ (C1 & ~C2) *)
(* precondition: true *)
(*
 let %op0 = xor %x, C1 in 
 let %r = or %op0, C in 

=>
 let %or = or %x, C in 
 let %op0 = xor %x, C1 in 
 let %r = xor %or, (C1 & ~C) in 

*)
let alive_AndOrXor_2063__X__C1__C2____X__C2__C1__C2 (w : pos) (input_c input_x input_c1 : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_c1) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_xor w var_3 in
  let var_5 = op_const (input_c) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_or w var_6 in
  (* return_value *) var_7) == (
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_c) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_or w var_3 in
  let var_5 = op_const (input_c1) var_0 in
  let var_6 = (var_1, var_5) in
  let var_7 = op_xor w var_6 in
  let var_8 = op_not w var_2 in
  let var_9 = (var_5, var_8) in
  let var_10 = op_and w var_9 in
  let var_11 = (var_4, var_10) in
  let var_12 = op_xor w var_11 in
  (* return_value *) var_12))
 = ()