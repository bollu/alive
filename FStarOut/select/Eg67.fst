module Eg67

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



(* Name:Select:1105 *)
(* precondition: true *)
(*
 let %r = select i1 false, %X, %Y in 

=>
 let %r = %Y in 

*)
let alive_Select_1105 (w : pos) (input_x input_y : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (↑false) var_0 in
  let var_2 = op_const (input_x) var_0 in
  let var_3 = op_const (input_y) var_0 in
  let var_4 = triple:var_1 var_2 var_3 in
  let var_5 = op_select w var_4 in
  (* return_value *) var_5) == (
  let var_0 = () in
  let var_1 = op_const (input_y) var_0 in
  let var_2 = op_copy w var_1 in
  (* return_value *) var_2))
 = ()