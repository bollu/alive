
module Alive
open Alive.AST
open FStar.BV


(* Name:AddSub:1043 *)
(* precondition: true *)
(*
 let %Y = and %Z, C1 in 
 let %X = xor %Y, C1 in 
 let %LHS = add %X, 1 in 
 let %r = add %LHS, %RHS in 

=>
 let %or = or %Z, ~C1 in 
 let %Y = and %Z, C1 in 
 let %X = xor %Y, C1 in 
 let %LHS = add %X, 1 in 
 let %r = sub %RHS, %or in 

*)
let alive_AddSub_1043 (w : pos) (input_rhs input_z input_c1 : BV.bv_t w)
 : Lemma ((
  let var_0 = unit in
  let var_1 = op_const (input_z) var_0 in
  let var_2 = op_const (input_c1) var_0 in
  let var_3 = pair var_1 var_2 in
  let var_4 = op_and w var_3 in
  let var_5 = pair var_4 var_2 in
  let var_6 = op_xor w var_5 in
  let var_7 = op_const (1) var_0 in
  let var_8 = pair var_6 var_7 in
  let var_9 = op_add w var_8 in
  let var_10 = op_const (input_rhs) var_0 in
  let var_11 = pair var_9 var_10 in
  let var_12 = op_add w var_11 in
  (* return_value *) var_12) == (
  let var_0 = unit in
  let var_1 = op_const (input_z) var_0 in
  let var_2 = op_const (input_c1) var_0 in
  let var_3 = op_not w var_2 in
  let var_4 = pair var_1 var_3 in
  let var_5 = op_or w var_4 in
  let var_6 = pair var_1 var_2 in
  let var_7 = op_and w var_6 in
  let var_8 = pair var_7 var_2 in
  let var_9 = op_xor w var_8 in
  let var_10 = op_const (1) var_0 in
  let var_11 = pair var_9 var_10 in
  let var_12 = op_add w var_11 in
  let var_13 = op_const (input_rhs) var_0 in
  let var_14 = pair var_13 var_5 in
  let var_15 = op_sub w var_14 in
  (* return_value *) var_15))
 = ()