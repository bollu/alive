module Eg32

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



(* Name:SimplifyDivRemOfSelect *)
(* precondition: true *)
(*
 let %sel = select i1 %c, %Y, 0 in 
 let %r = udiv %X, %sel in 

=>
 let %sel = select i1 %c, %Y, 0 in 
 let %r = udiv %X, %Y in 

*)
let alive_SimplifyDivRemOfSelect (w : pos) (input_c input_x input_y : BV.bv_t 1)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_c) var_0 in
  let var_2 = op_const (input_y) var_0 in
  let var_3 = op_const (BV.int2bv 0) var_0 in
  let var_4 = triple:var_1 var_2 var_3 in
  let var_5 = op_select w var_4 in
  let var_6 = op_const (input_x) var_0 in
  let var_7 = (var_6, var_5) in
  let var_8 = op_udiv w var_7 in
  (* return_value *) var_8) == (
  let var_0 = () in
  let var_1 = op_const (input_c) var_0 in
  let var_2 = op_const (input_y) var_0 in
  let var_3 = op_const (BV.int2bv 0) var_0 in
  let var_4 = triple:var_1 var_2 var_3 in
  let var_5 = op_select 1 var_4 in
  let var_6 = op_const (input_x) var_0 in
  let var_7 = (var_6, var_2) in
  let var_8 = op_udiv 1 var_7 in
  (* return_value *) var_8))
 = ()