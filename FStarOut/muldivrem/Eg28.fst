module Eg28

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



(* Name:276-2 *)
(* precondition: true *)
(*
 let %div = udiv i5 %X, %Y in 
 let %negY = sub 0, %Y in 
 let %r = mul %div, %negY in 

=>
 let %rem = urem %X, %Y in 
 let %div = udiv i5 %X, %Y in 
 let %negY = sub 0, %Y in 
 let %r = sub %rem, %X in 

*)
let alive_276_2 (input_x input_y : BV.bv_t 5)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_y) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_udiv 5 var_3 in
  let var_5 = op_const (BV.int2bv 0) var_0 in
  let var_6 = (var_5, var_2) in
  let var_7 = op_sub 5 var_6 in
  let var_8 = (var_4, var_7) in
  let var_9 = op_mul 5 var_8 in
  (* return_value *) var_9) == (
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_y) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_urem 5 var_3 in
  let var_5 = (var_1, var_2) in
  let var_6 = op_udiv 5 var_5 in
  let var_7 = op_const (BV.int2bv 0) var_0 in
  let var_8 = (var_7, var_2) in
  let var_9 = op_sub 5 var_8 in
  let var_10 = (var_4, var_1) in
  let var_11 = op_sub 5 var_10 in
  (* return_value *) var_11))
 = ()