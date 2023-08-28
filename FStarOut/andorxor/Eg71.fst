module Eg71

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



(* Name:AndOrXor:1288 (A ^ B) & ((B ^ C) ^ A) -> (A ^ B) & ~C *)
(* precondition: true *)
(*
 let %op0 = xor %A, %B in 
 let %x = xor %B, %C in 
 let %op1 = xor %x, %A in 
 let %r = and %op0, %op1 in 

=>
 let %op0 = xor %A, %B in 
 let %negC = xor %C, -1 in 
 let %x = xor %B, %C in 
 let %op1 = xor %x, %A in 
 let %r = and %op0, %negC in 

*)
let alive_AndOrXor_1288_A__B__B__C__A___A__B__C (w : pos) (input_b input_c input_a : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_b) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_xor w var_3 in
  let var_5 = op_const (input_c) var_0 in
  let var_6 = (var_2, var_5) in
  let var_7 = op_xor w var_6 in
  let var_8 = (var_7, var_1) in
  let var_9 = op_xor w var_8 in
  let var_10 = (var_4, var_9) in
  let var_11 = op_and w var_10 in
  (* return_value *) var_11) == (
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_b) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_xor w var_3 in
  let var_5 = op_const (input_c) var_0 in
  let var_6 = op_const (BV.int2bv -1) var_0 in
  let var_7 = (var_5, var_6) in
  let var_8 = op_xor w var_7 in
  let var_9 = (var_2, var_5) in
  let var_10 = op_xor w var_9 in
  let var_11 = (var_10, var_1) in
  let var_12 = op_xor w var_11 in
  let var_13 = (var_4, var_8) in
  let var_14 = op_and w var_13 in
  (* return_value *) var_14))
 = ()