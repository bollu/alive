module Eg88

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



(* Name:AndOrXor:1705 *)
(* precondition: true *)
(*
 let %cmp1 = icmp eq %B, 0 in 
 let %cmp2 = icmp ugt %B, %A in 
 let %r = or %cmp1, %cmp2 in 

=>
 let %b1 = add %B, -1 in 
 let %cmp1 = icmp eq %B, 0 in 
 let %cmp2 = icmp ugt %B, %A in 
 let %r = icmp uge %b1, %A in 

*)
let alive_AndOrXor_1705 (w : pos) (input_b input_a : BV.bv_t w)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_b) var_0 in
  let var_2 = op_const (BV.int2bv 0) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_icmp eq  w var_3 in
  let var_5 = op_const (input_a) var_0 in
  let var_6 = (var_1, var_5) in
  let var_7 = op_icmp ugt  w var_6 in
  let var_8 = (var_4, var_7) in
  let var_9 = op_or 1 var_8 in
  (* return_value *) var_9) == (
  let var_0 = () in
  let var_1 = op_const (input_b) var_0 in
  let var_2 = op_const (BV.int2bv -1) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_add w var_3 in
  let var_5 = op_const (BV.int2bv 0) var_0 in
  let var_6 = (var_1, var_5) in
  let var_7 = op_icmp eq  w var_6 in
  let var_8 = op_const (input_a) var_0 in
  let var_9 = (var_1, var_8) in
  let var_10 = op_icmp ugt  w var_9 in
  let var_11 = (var_4, var_8) in
  let var_12 = op_icmp uge  w var_11 in
  (* return_value *) var_12))
 = ()