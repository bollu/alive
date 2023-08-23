module Eg44

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



(* Name:AddSub:1619 *)
(* precondition: true *)
(*
 let %Op0 = sub %X, %Y in 
 let %r = sub %Op0, %X in 

=>
 let %Op0 = sub %X, %Y in 
 let %r = sub 0, %Y in 

*)
let alive_AddSub_1619 (w : pos) (input_x input_y : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_y) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_sub w var_3 in
  let var_5 = (var_4, var_1) in
  let var_6 = op_sub w var_5 in
  (* return_value *) var_6) == (
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (input_y) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_sub w var_3 in
  let var_5 = op_const (BV.int2bv 0) var_0 in
  let var_6 = (var_5, var_2) in
  let var_7 = op_sub w var_6 in
  (* return_value *) var_7))
 = ()