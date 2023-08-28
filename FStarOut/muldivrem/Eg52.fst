module Eg52

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



(* Name:820' *)
(* precondition: true *)
(*
 let %Z = urem i9 %X, %Op1 in 
 let %Op0 = sub %X, %Z in 
 let %r = udiv %Op0, %Op1 in 

=>
 let %Z = urem i9 %X, %Op1 in 
 let %Op0 = sub %X, %Z in 
 let %r = udiv %X, %Op1 in 

*)
let alive_820' (input_x input_op1 : BV.bv_t 9)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_op1) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_urem 9 var_3 in
  let var_5 = (var_1, var_4) in
  let var_6 = op_sub 9 var_5 in
  let var_7 = (var_6, var_2) in
  let var_8 = op_udiv 9 var_7 in
  (* return_value *) var_8) == (
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_op1) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_urem 9 var_3 in
  let var_5 = (var_1, var_4) in
  let var_6 = op_sub 9 var_5 in
  let var_7 = (var_1, var_2) in
  let var_8 = op_udiv 9 var_7 in
  (* return_value *) var_8))
 = ()