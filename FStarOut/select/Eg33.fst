module Eg33

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



(* Name:Select:700 *)
(* precondition: true *)
(*
 let %c = icmp slt %A, %B in 
 let %smin = select i1 %c, %A, %B in 
 let %c2 = icmp slt %smin, %B in 
 let %smin2 = select i1 %c2, %smin, %B in 

=>
 let %c = icmp slt %A, %B in 
 let %smin = select i1 %c, %A, %B in 
 let %c2 = icmp slt %smin, %B in 
 let %smin2 = select i1 %c, %A, %B in 

*)
let alive_Select_700 (w : pos) (input_b input_a : BV.bv_t 1)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_b) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_icmp slt  w var_3 in
  let var_5 = triple:var_4 var_1 var_2 in
  let var_6 = op_select 1 var_5 in
  let var_7 = (var_6, var_2) in
  let var_8 = op_icmp slt  w var_7 in
  let var_9 = triple:var_8 var_6 var_2 in
  let var_10 = op_select 1 var_9 in
  (* return_value *) var_10) == (
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (input_b) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_icmp slt  1 var_3 in
  let var_5 = triple:var_4 var_1 var_2 in
  let var_6 = op_select 1 var_5 in
  let var_7 = (var_6, var_2) in
  let var_8 = op_icmp slt  1 var_7 in
  let var_9 = triple:var_4 var_1 var_2 in
  let var_10 = op_select 1 var_9 in
  (* return_value *) var_10))
 = ()