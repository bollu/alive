module Eg141

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



(* Name:AndOrXor:2375 *)
(* precondition: true *)
(*
 let %op0 = select i1 %x, %A, %B in 
 let %op1 = select i1 %x, %C, %D in 
 let %r = or %op0, %op1 in 

=>
 let %t = or %A, %C in 
 let %f = or %B, %D in 
 let %op0 = select i1 %x, %A, %B in 
 let %op1 = select i1 %x, %C, %D in 
 let %r = select i1 %x, %t, %f in 

*)
let alive_AndOrXor_2375 (w : pos) (input_d input_b input_c input_x input_a : BV.bv_t 1)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_a) var_0 in
  let var_3 = op_const (input_b) var_0 in
  let var_4 = triple:var_1 var_2 var_3 in
  let var_5 = op_select w var_4 in
  let var_6 = op_const (input_c) var_0 in
  let var_7 = op_const (input_d) var_0 in
  let var_8 = triple:var_1 var_6 var_7 in
  let var_9 = op_select w var_8 in
  let var_10 = (var_5, var_9) in
  let var_11 = op_or w var_10 in
  (* return_value *) var_11) == (
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_c) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_or 1 var_3 in
  let var_5 = op_const (input_b) var_0 in
  let var_6 = op_const (input_d) var_0 in
  let var_7 = (var_5, var_6) in
  let var_8 = op_or 1 var_7 in
  let var_9 = op_const (input_x) var_0 in
  let var_10 = triple:var_9 var_1 var_5 in
  let var_11 = op_select 1 var_10 in
  let var_12 = triple:var_9 var_2 var_6 in
  let var_13 = op_select 1 var_12 in
  let var_14 = triple:var_9 var_4 var_8 in
  let var_15 = op_select 1 var_14 in
  (* return_value *) var_15))
 = ()