module Eg163

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



(* Name:AndOrXor:2663 *)
(* precondition: true *)
(*
 let %op0 = icmp ule %a, %b in 
 let %op1 = icmp ne %a, %b in 
 let %r = xor %op0, %op1 in 

=>
 let %op0 = icmp ule %a, %b in 
 let %op1 = icmp ne %a, %b in 
 let %r = icmp uge %a, %b in 

*)
let alive_AndOrXor_2663 (w : pos) (input_b input_a : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_b) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_icmp ule  w var_3 in
  let var_5 = (var_1, var_2) in
  let var_6 = op_icmp ne  w var_5 in
  let var_7 = (var_4, var_6) in
  let var_8 = op_xor 1 var_7 in
  (* return_value *) var_8) == (
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_b) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_icmp ule  w var_3 in
  let var_5 = (var_1, var_2) in
  let var_6 = op_icmp ne  w var_5 in
  let var_7 = (var_1, var_2) in
  let var_8 = op_icmp uge  w var_7 in
  (* return_value *) var_8))
 = ()