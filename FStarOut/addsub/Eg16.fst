module Eg16

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



(* Name:AddSub:1165 *)
(* precondition: true *)
(*
 let %na = sub 0, %a in 
 let %nb = sub 0, %b in 
 let %c = add %na, %nb in 

=>
 let %ab = add %a, %b in 
 let %na = sub 0, %a in 
 let %nb = sub 0, %b in 
 let %c = sub 0, %ab in 

*)
let alive_AddSub_1165 (w : pos) (input_b input_a : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (BV.int2bv 0) var_0 in
  let var_2 = op_const (input_a) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_sub w var_3 in
  let var_5 = op_const (BV.int2bv 0) var_0 in
  let var_6 = op_const (input_b) var_0 in
  let var_7 = (var_5, var_6) in
  let var_8 = op_sub w var_7 in
  let var_9 = (var_4, var_8) in
  let var_10 = op_add w var_9 in
  (* return_value *) var_10) == (
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_b) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_add w var_3 in
  let var_5 = op_const (BV.int2bv 0) var_0 in
  let var_6 = (var_5, var_1) in
  let var_7 = op_sub w var_6 in
  let var_8 = op_const (BV.int2bv 0) var_0 in
  let var_9 = (var_8, var_2) in
  let var_10 = op_sub w var_9 in
  let var_11 = op_const (BV.int2bv 0) var_0 in
  let var_12 = (var_11, var_4) in
  let var_13 = op_sub w var_12 in
  (* return_value *) var_13))
 = ()