module Eg49

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



(* Name:805 *)
(* precondition: true *)
(*
 let %r = sdiv 1, %X in 

=>
 let %inc = add %X, 1 in 
 let %c = icmp ult %inc, 3 in 
 let %r = select i1 %c, %X, 0 in 

*)
let alive_805 (w : pos) (input_x : BV.bv_t 1)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (BV.int2bv 1) var_0 in
  let var_2 = op_const (input_x) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_sdiv w var_3 in
  (* return_value *) var_4) == (
  let var_0 = () in
  let var_1 = op_const (input_x) var_0 in
  let var_2 = op_const (BV.int2bv 1) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_add w var_3 in
  let var_5 = op_const (#w) (BV.int2bv (3)) var_0 in
  let var_6 = (var_4, var_5) in
  let var_7 = op_icmp ult  w var_6 in
  let var_8 = op_const (BV.int2bv 0) var_0 in
  let var_9 = triple:var_7 var_1 var_8 in
  let var_10 = op_select w var_9 in
  (* return_value *) var_10))
 = ()