module Eg72

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



(* Name:AndOrXor:1294 (A | B) & ((~A) ^ B) -> (A & B) *)
(* precondition: true *)
(*
 let %op0 = or %A, %B in 
 let %x = xor %A, -1 in 
 let %op1 = xor %x, %B in 
 let %r = and %op0, %op1 in 

=>
 let %op0 = or %A, %B in 
 let %x = xor %A, -1 in 
 let %op1 = xor %x, %B in 
 let %r = and %A, %B in 

*)
let alive_AndOrXor_1294_A__B__A__B___A__B (w : pos) (input_b input_a : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_b) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_or w var_3 in
  let var_5 = op_const (BV.int2bv -1) var_0 in
  let var_6 = (var_1, var_5) in
  let var_7 = op_xor w var_6 in
  let var_8 = (var_7, var_2) in
  let var_9 = op_xor w var_8 in
  let var_10 = (var_4, var_9) in
  let var_11 = op_and w var_10 in
  (* return_value *) var_11) == (
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_b) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_or w var_3 in
  let var_5 = op_const (BV.int2bv -1) var_0 in
  let var_6 = (var_1, var_5) in
  let var_7 = op_xor w var_6 in
  let var_8 = (var_7, var_2) in
  let var_9 = op_xor w var_8 in
  let var_10 = (var_1, var_2) in
  let var_11 = op_and w var_10 in
  (* return_value *) var_11))
 = ()