module Eg146

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



(* Name:AndOrXor:2443 *)
(* precondition: true *)
(*
 let %nx = xor %x, -1 in 
 let %op0 = ashr %nx, %y in 
 let %r = xor %op0, -1 in 

=>
 let %nx = xor %x, -1 in 
 let %op0 = ashr %nx, %y in 
 let %r = ashr %x, %y in 

*)
let alive_AndOrXor_2443 (w : pos) (input_x input_y : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (BV.int2bv -1) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_xor w var_3 in
  let var_5 = op_const (input_y) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_ashr w var_6 in
  let var_8 = op_const (BV.int2bv -1) var_0 in
  let var_9 = (var_7, var_8) in
  let var_10 = op_xor w var_9 in
  (* return_value *) var_10) == (
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (BV.int2bv -1) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_xor w var_3 in
  let var_5 = op_const (input_y) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_ashr w var_6 in
  let var_8 = (var_1, var_5) in
  let var_9 = op_ashr w var_8 in
  (* return_value *) var_9))
 = ()