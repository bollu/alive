module Eg24

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



(* Name:AndOrXor:698 *)
(* precondition: true *)
(*
 let %a1 = and %a, %b in 
 let %a2 = and %a, %d in 
 let %op0 = icmp eq %a1, 0 in 
 let %op1 = icmp eq %a2, 0 in 
 let %r = and %op0, %op1 in 

=>
 let %or = or %b, %d in 
 let %a3 = and %a, %or in 
 let %a1 = and %a, %b in 
 let %a2 = and %a, %d in 
 let %op0 = icmp eq %a1, 0 in 
 let %op1 = icmp eq %a2, 0 in 
 let %r = icmp eq %a3, 0 in 

*)
let alive_AndOrXor_698 (w : pos) (input_d input_b input_a : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_b) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_and w var_3 in
  let var_5 = op_const (input_d) var_0 in
  let var_6 = (var_1, var_5) in
  let var_7 = op_and w var_6 in
  let var_8 = op_const (BV.int2bv 0) var_0 in
  let var_9 = (var_4, var_8) in
  let var_10 = op_icmp eq  w var_9 in
  let var_11 = op_const (BV.int2bv 0) var_0 in
  let var_12 = (var_7, var_11) in
  let var_13 = op_icmp eq  w var_12 in
  let var_14 = (var_10, var_13) in
  let var_15 = op_and 1 var_14 in
  (* return_value *) var_15) == (
  let var_0 = () in
  let var_1 = op_const (input_b) var_0 in
  let var_2 = op_const (input_d) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_or w var_3 in
  let var_5 = op_const (input_a) var_0 in
  let var_6 = (var_5, var_4) in
  let var_7 = op_and w var_6 in
  let var_8 = (var_5, var_1) in
  let var_9 = op_and w var_8 in
  let var_10 = (var_5, var_2) in
  let var_11 = op_and w var_10 in
  let var_12 = op_const (BV.int2bv 0) var_0 in
  let var_13 = (var_9, var_12) in
  let var_14 = op_icmp eq  w var_13 in
  let var_15 = op_const (BV.int2bv 0) var_0 in
  let var_16 = (var_11, var_15) in
  let var_17 = op_icmp eq  w var_16 in
  let var_18 = op_const (BV.int2bv 0) var_0 in
  let var_19 = (var_7, var_18) in
  let var_20 = op_icmp eq  w var_19 in
  (* return_value *) var_20))
 = ()