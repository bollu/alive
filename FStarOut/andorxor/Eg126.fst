module Eg126

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



(* Name:AndOrXor:2188 *)
(* precondition: true *)
(*
 let %C = xor %D, -1 in 
 let %B = xor %A, -1 in 
 let %op0 = and %A, %C in 
 let %op1 = and %B, %D in 
 let %r = or %op0, %op1 in 

=>
 let %C = xor %D, -1 in 
 let %B = xor %A, -1 in 
 let %op0 = and %A, %C in 
 let %op1 = and %B, %D in 
 let %r = xor %A, %D in 

*)
let alive_AndOrXor_2188 (w : pos) (input_d input_a : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_d) var_0 in
  let var_2 = op_const (BV.int2bv -1) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_xor w var_3 in
  let var_5 = op_const (input_a) var_0 in
  let var_6 = op_const (BV.int2bv -1) var_0 in
  let var_7 = (var_5, var_6) in
  let var_8 = op_xor w var_7 in
  let var_9 = (var_5, var_4) in
  let var_10 = op_and w var_9 in
  let var_11 = (var_8, var_1) in
  let var_12 = op_and w var_11 in
  let var_13 = (var_10, var_12) in
  let var_14 = op_or w var_13 in
  (* return_value *) var_14) == (
  let var_0 = () in
  let var_1 = op_const (input_d) var_0 in
  let var_2 = op_const (BV.int2bv -1) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_xor w var_3 in
  let var_5 = op_const (input_a) var_0 in
  let var_6 = op_const (BV.int2bv -1) var_0 in
  let var_7 = (var_5, var_6) in
  let var_8 = op_xor w var_7 in
  let var_9 = (var_5, var_4) in
  let var_10 = op_and w var_9 in
  let var_11 = (var_8, var_1) in
  let var_12 = op_and w var_11 in
  let var_13 = (var_5, var_1) in
  let var_14 = op_xor w var_13 in
  (* return_value *) var_14))
 = ()