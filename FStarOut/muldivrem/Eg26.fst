module Eg26

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



(* Name:275-2 *)
(* precondition: true *)
(*
 let %div = sdiv i5 %X, %Y in 
 let %r = mul %div, %Y in 

=>
 let %rem = srem %X, %Y in 
 let %div = sdiv i5 %X, %Y in 
 let %r = sub %X, %rem in 

*)
let alive_275_2 (input_x input_y : BV.bv_t 5)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_y) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_sdiv 5 var_3 in
  let var_5 = (var_4, var_2) in
  let var_6 = op_mul 5 var_5 in
  (* return_value *) var_6) == (
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_y) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_srem 5 var_3 in
  let var_5 = (var_1, var_2) in
  let var_6 = op_sdiv 5 var_5 in
  let var_7 = (var_1, var_4) in
  let var_8 = op_sub 5 var_7 in
  (* return_value *) var_8))
 = ()