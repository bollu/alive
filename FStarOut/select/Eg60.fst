module Eg60

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



(* Name:Select:962 *)
(* precondition: true *)
(*
 let %s1 = add %x, %y in 
 let %s2 = add %x, %z in 
 let %r = select i1 %c, %s1, %s2 in 

=>
 let %yz = select i1 %c, %y, %z in 
 let %s1 = add %x, %y in 
 let %s2 = add %x, %z in 
 let %r = add %x, %yz in 

*)
let alive_Select_962 (w : pos) (input_z input_c input_y : BV.bv_t 1)
(input_x : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_y) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_add w var_3 in
  let var_5 = op_const (input_z) var_0 in
  let var_6 = (var_1, var_5) in
  let var_7 = op_add w var_6 in
  let var_8 = op_const (input_c) var_0 in
  let var_9 = triple:var_8 var_4 var_7 in
  let var_10 = op_select w var_9 in
  (* return_value *) var_10) == (
  let var_0 = () in
  let var_1 = op_const (input_c) var_0 in
  let var_2 = op_const (input_y) var_0 in
  let var_3 = op_const (input_z) var_0 in
  let var_4 = triple:var_1 var_2 var_3 in
  let var_5 = op_select w var_4 in
  let var_6 = op_const (input_x) var_0 in
  let var_7 = (var_6, var_2) in
  let var_8 = op_add w var_7 in
  let var_9 = (var_6, var_3) in
  let var_10 = op_add w var_9 in
  let var_11 = (var_6, var_5) in
  let var_12 = op_add w var_11 in
  (* return_value *) var_12))
 = ()