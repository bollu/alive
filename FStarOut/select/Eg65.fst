module Eg65

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



(* Name:Select:1087 *)
(* precondition: true *)
(*
 let %c = xor i1 %val, true in 
 let %r = select i1 %c, %X, %Y in 

=>
 let %c = xor i1 %val, true in 
 let %r = select i1 %val, %Y, %X in 

*)
let alive_Select_1087 (w : pos) (input_val input_x input_y : BV.bv_t 1)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_val) var_0 in
  let var_2 = op_const (↑true) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_xor 1 var_3 in
  let var_5 = op_const (input_x) var_0 in
  let var_6 = op_const (input_y) var_0 in
  let var_7 = triple:var_4 var_5 var_6 in
  let var_8 = op_select w var_7 in
  (* return_value *) var_8) == (
  let var_0 = () in
  let var_1 = op_const (input_val) var_0 in
  let var_2 = op_const (↑true) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_xor 1 var_3 in
  let var_5 = op_const (input_y) var_0 in
  let var_6 = op_const (input_x) var_0 in
  let var_7 = triple:var_1 var_5 var_6 in
  let var_8 = op_select w var_7 in
  (* return_value *) var_8))
 = ()