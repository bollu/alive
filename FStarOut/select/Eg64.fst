module Eg64

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



(* Name:Select:1078 *)
(* precondition: true *)
(*
 let %Y = select i1 %c, %W, %Z in 
 let %r = select i1 %c, %X, %Y in 

=>
 let %Y = select i1 %c, %W, %Z in 
 let %r = select i1 %c, %X, %Z in 

*)
let alive_Select_1078 (w : pos) (input_w input_z input_c input_x : BV.bv_t 1)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_c) var_0 in
  let var_2 = op_const (input_w) var_0 in
  let var_3 = op_const (input_z) var_0 in
  let var_4 = triple:var_1 var_2 var_3 in
  let var_5 = op_select w var_4 in
  let var_6 = op_const (input_x) var_0 in
  let var_7 = triple:var_1 var_6 var_5 in
  let var_8 = op_select w var_7 in
  (* return_value *) var_8) == (
  let var_0 = () in
  let var_1 = op_const (input_c) var_0 in
  let var_2 = op_const (input_w) var_0 in
  let var_3 = op_const (input_z) var_0 in
  let var_4 = triple:var_1 var_2 var_3 in
  let var_5 = op_select 1 var_4 in
  let var_6 = op_const (input_x) var_0 in
  let var_7 = triple:var_1 var_6 var_3 in
  let var_8 = op_select 1 var_7 in
  (* return_value *) var_8))
 = ()