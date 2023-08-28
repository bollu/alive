module Eg51

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



(* Name:Select:859 *)
(* precondition: true *)
(*
 let %A = select i1 %B, %C, true in 

=>
 let %notb = xor i1 %B, true in 
 let %A = or %notb, %C in 

*)
let alive_Select_859 (input_b input_c : BV.bv_t 1)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_b) var_0 in
  let var_2 = op_const (input_c) var_0 in
  let var_3 = op_const (↑true) var_0 in
  let var_4 = triple:var_1 var_2 var_3 in
  let var_5 = op_select 1 var_4 in
  (* return_value *) var_5) == (
  let var_0 = () in
  let var_1 = op_const (input_b) var_0 in
  let var_2 = op_const (↑true) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_xor 1 var_3 in
  let var_5 = op_const (input_c) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_or 1 var_6 in
  (* return_value *) var_7))
 = ()