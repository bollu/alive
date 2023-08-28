module Eg41

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



(* Name:Select:741 *)
(* precondition: true *)
(*
 let %c = icmp sgt %A, 0 in 
 let %minus = sub 0, %A in 
 let %abs = select i1 %c, %minus, %A in 
 let %c2 = icmp sgt %abs, -1 in 
 let %minus2 = sub 0, %abs in 
 let %abs2 = select i1 %c2, %minus2, %abs in 

=>
 let %c = icmp sgt %A, 0 in 
 let %minus = sub 0, %A in 
 let %abs = select i1 %c, %minus, %A in 
 let %c2 = icmp sgt %abs, -1 in 
 let %minus2 = sub 0, %abs in 
 let %abs2 = select i1 %c, %minus, %A in 

*)
let alive_Select_741 (w : pos) (input_a : BV.bv_t 1)
 : Lemma ((
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (BV.int2bv 0) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_icmp sgt  w var_3 in
  let var_5 = op_const (BV.int2bv 0) var_0 in
  let var_6 = (var_5, var_1) in
  let var_7 = op_sub 1 var_6 in
  let var_8 = triple:var_4 var_7 var_1 in
  let var_9 = op_select w var_8 in
  let var_10 = op_const (BV.int2bv -1) var_0 in
  let var_11 = (var_9, var_10) in
  let var_12 = op_icmp sgt  w var_11 in
  let var_13 = op_const (BV.int2bv 0) var_0 in
  let var_14 = (var_13, var_9) in
  let var_15 = op_sub w var_14 in
  let var_16 = triple:var_12 var_15 var_9 in
  let var_17 = op_select w var_16 in
  (* return_value *) var_17) == (
  let var_0 = () in
  let var_1 = op_const (input_a) var_0 in
  let var_2 = op_const (BV.int2bv 0) var_0 in
  let var_3 = (var_1, var_2) in
  let var_4 = op_icmp sgt  1 var_3 in
  let var_5 = op_const (BV.int2bv 0) var_0 in
  let var_6 = (var_5, var_1) in
  let var_7 = op_sub 1 var_6 in
  let var_8 = triple:var_4 var_7 var_1 in
  let var_9 = op_select 1 var_8 in
  let var_10 = op_const (BV.int2bv -1) var_0 in
  let var_11 = (var_9, var_10) in
  let var_12 = op_icmp sgt  1 var_11 in
  let var_13 = op_const (BV.int2bv 0) var_0 in
  let var_14 = (var_13, var_9) in
  let var_15 = op_sub 1 var_14 in
  let var_16 = triple:var_4 var_7 var_1 in
  let var_17 = op_select 1 var_16 in
  (* return_value *) var_17))
 = ()