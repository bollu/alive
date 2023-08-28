module Eg128

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



(* Name:AndOrXor:2243  ((B | C) & A) | B -> B | (A & C) *)
(* precondition: true *)
(*
 let %o = or %B, %C in 
 let %op0 = and %o, %A in 
 let %r = or %op0, %B in 

=>
 let %a = and %A, %C in 
 let %o = or %B, %C in 
 let %op0 = and %o, %A in 
 let %r = or %B, %a in 

*)
let alive_AndOrXor_2243__B__C__A__B___B__A__C (w : pos) (input_b input_c input_a : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_b) var_0 in
  let var_2 = op_const (input_c) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_or w var_3 in
  let var_5 = op_const (input_a) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_and w var_6 in
  let var_8 = (var_7, var_1) in
  let var_9 = op_or w var_8 in
  (* return_value *) var_9) == (
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_c) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_and w var_3 in
  let var_5 = op_const (input_b) var_0 in
  let var_6 = (var_5, var_2) in
  let var_7 = op_or w var_6 in
  let var_8 = (var_7, var_1) in
  let var_9 = op_and w var_8 in
  let var_10 = (var_5, var_4) in
  let var_11 = op_or w var_10 in
  (* return_value *) var_11))
 = ()