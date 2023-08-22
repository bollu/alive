
module Alive
open Alive.AST
open FStar.BV


(* Name:AddSub:1043 *)
(* precondition: true *)
(*
let  %Y = and %Z, C1
let  %X = xor %Y, C1
let  %LHS = add %X, 1
let  %r = add %LHS, %RHS

=>
let  %or = or %Z, ~C1
let  %Y = and %Z, C1
let  %X = xor %Y, C1
let  %LHS = add %X, 1
let  %r = sub %RHS, %or

*)
let alive_AddSub_1043 : forall (w : pos) (C1 Z RHS : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (Z) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:xor w %v5;
  %v7 := op:const (1) %v0;
  %v8 := pair:%v6 %v7;
  %v9 := op:add w %v8;
  %v10 := op:const (RHS) %v0;
  %v11 := pair:%v9 %v10;
  %v12 := op:add w %v11
  dsl_ret %v12 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (Z) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := op:not w %v2;
  %v4 := pair:%v1 %v3;
  %v5 := op:or w %v4;
  %v6 := pair:%v1 %v2;
  %v7 := op:and w %v6;
  %v8 := pair:%v7 %v2;
  %v9 := op:xor w %v8;
  %v10 := op:const (1) %v0;
  %v11 := pair:%v9 %v10;
  %v12 := op:add w %v11;
  %v13 := op:const (RHS) %v0;
  %v14 := pair:%v13 %v5;
  %v15 := op:sub w %v14
  dsl_ret %v15)
 = ()

(* Name:AddSub:1152 *)
(* precondition: true *)
(*
let  %r = add i1 %x, %y

=>
let  %r = xor %x, %y

*)
let alive_AddSub_1152: forall (y x : BV.bv_t 1)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add 1 %v3
  dsl_ret %v4 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor 1 %v3
  dsl_ret %v4)
 = ()

(* Name:AddSub:1156 *)
(* precondition: true *)
(*
let  %a = add %b, %b

=>
let  %a = shl %b, 1

*)
let alive_AddSub_1156 : forall (w : pos) (b : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := pair:%v1 %v1;
  %v3 := op:add w %v2
  dsl_ret %v3 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := op:const (1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3
  dsl_ret %v4)
 = ()

(* Name:AddSub:1164 *)
(* precondition: true *)
(*
let  %na = sub 0, %a
let  %c = add %na, %b

=>
let  %na = sub 0, %a
let  %c = sub %b, %a

*)
let alive_AddSub_1164 : forall (w : pos) (a b : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (0) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (b) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:add w %v6
  dsl_ret %v7 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (0) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (b) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6
  dsl_ret %v7)
 = ()

(* Name:AddSub:1165 *)
(* precondition: true *)
(*
let  %na = sub 0, %a
let  %nb = sub 0, %b
let  %c = add %na, %nb

=>
let  %ab = add %a, %b
let  %na = sub 0, %a
let  %nb = sub 0, %b
let  %c = sub 0, %ab

*)
let alive_AddSub_1165 : forall (w : pos) (a b : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (0) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (0) %v0;
  %v6 := op:const (b) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:sub w %v7;
  %v9 := pair:%v4 %v8;
  %v10 := op:add w %v9
  dsl_ret %v10 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (0) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:sub w %v6;
  %v8 := op:const (0) %v0;
  %v9 := pair:%v8 %v2;
  %v10 := op:sub w %v9;
  %v11 := op:const (0) %v0;
  %v12 := pair:%v11 %v4;
  %v13 := op:sub w %v12
  dsl_ret %v13)
 = ()

(* Name:AddSub:1176 *)
(* precondition: true *)
(*
let  %nb = sub 0, %b
let  %c = add %a, %nb

=>
let  %nb = sub 0, %b
let  %c = sub %a, %b

*)
let alive_AddSub_1176 : forall (w : pos) (a b : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (0) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (a) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:add w %v6
  dsl_ret %v7 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (0) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (a) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6
  dsl_ret %v7)
 = ()

(* Name:AddSub:1202 *)
(* precondition: true *)
(*
let  %nx = xor %x, -1
let  %r = add %nx, C

=>
let  %nx = xor %x, -1
let  %r = sub (C - 1), %x

*)
let alive_AddSub_1202 : forall (w : pos) (x C : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (-1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:add w %v6
  dsl_ret %v7 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (-1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := op:const (1) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:sub w %v7;
  %v9 := pair:%v8 %v1;
  %v10 := op:sub w %v9
  dsl_ret %v10)
 = ()

(* Name:AddSub:1295 *)
(* precondition: true *)
(*
let  %aab = and %a, %b
let  %aob = xor %a, %b
let  %c = add %aab, %aob

=>
let  %aab = and %a, %b
let  %aob = xor %a, %b
let  %c = or %a, %b

*)
let alive_AddSub_1295 : forall (w : pos) (a b : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:add w %v7
  dsl_ret %v8 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:or w %v7
  dsl_ret %v8)
 = ()

(* Name:AddSub:1309 *)
(* precondition: true *)
(*
let  %lhs = and %a, %b
let  %rhs = or %a, %b
let  %c = add %lhs, %rhs

=>
let  %lhs = and %a, %b
let  %rhs = or %a, %b
let  %c = add %a, %b

*)
let alive_AddSub_1309 : forall (w : pos) (a b : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:add w %v7
  dsl_ret %v8 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:add w %v7
  dsl_ret %v8)
 = ()

(* Name:AddSub:1539 *)
(* precondition: true *)
(*
let  %na = sub 0, %a
let  %r = sub %x, %na

=>
let  %na = sub 0, %a
let  %r = add %x, %a

*)
let alive_AddSub_1539 : forall (w : pos) (a x : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (0) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (x) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:sub w %v6
  dsl_ret %v7 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (0) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (x) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:add w %v6
  dsl_ret %v7)
 = ()

(* Name:AddSub:1539-2 *)
(* precondition: true *)
(*
let  %r = sub %x, C

=>
let  %r = add %x, -C

*)
let alive_AddSub_1539_2 : forall (w : pos) (x C : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3
  dsl_ret %v4 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (C) %v0;
  %v3 := op:neg w %v2;
  %v4 := pair:%v1 %v3;
  %v5 := op:add w %v4
  dsl_ret %v5)
 = ()

(* Name:AddSub:1556 *)
(* precondition: true *)
(*
let  %r = sub i1 %x, %y

=>
let  %r = xor %x, %y

*)
let alive_AddSub_1556: forall (y x : BV.bv_t 1)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub 1 %v3
  dsl_ret %v4 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor 1 %v3
  dsl_ret %v4)
 = ()

(* Name:AddSub:1560 *)
(* precondition: true *)
(*
let  %r = sub -1, %a

=>
let  %r = xor %a, -1

*)
let alive_AddSub_1560 : forall (w : pos) (a : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (-1) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3
  dsl_ret %v4 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (-1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3
  dsl_ret %v4)
 = ()

(* Name:AddSub:1564 *)
(* precondition: true *)
(*
let  %nx = xor %x, -1
let  %r = sub C, %nx

=>
let  %nx = xor %x, -1
let  %r = add %x, (C + 1)

*)
let alive_AddSub_1564 : forall (w : pos) (x C : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (-1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:sub w %v6
  dsl_ret %v7 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (-1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := op:const (1) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:add w %v7;
  %v9 := pair:%v1 %v8;
  %v10 := op:add w %v9
  dsl_ret %v10)
 = ()

(* Name:AddSub:1574 *)
(* precondition: true *)
(*
let  %rhs = add %X, C2
let  %r = sub C, %rhs

=>
let  %rhs = add %X, C2
let  %r = sub (C - C2), %X

*)
let alive_AddSub_1574 : forall (w : pos) (X C C2 : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C2) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:sub w %v6
  dsl_ret %v7 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C2) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6;
  %v8 := pair:%v7 %v1;
  %v9 := op:sub w %v8
  dsl_ret %v9)
 = ()

(* Name:AddSub:1614 *)
(* precondition: true *)
(*
let  %Op1 = add %X, %Y
let  %r = sub %X, %Op1

=>
let  %Op1 = add %X, %Y
let  %r = sub 0, %Y

*)
let alive_AddSub_1614 : forall (w : pos) (Y X : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := pair:%v1 %v4;
  %v6 := op:sub w %v5
  dsl_ret %v6 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (0) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6
  dsl_ret %v7)
 = ()

(* Name:AddSub:1619 *)
(* precondition: true *)
(*
let  %Op0 = sub %X, %Y
let  %r = sub %Op0, %X

=>
let  %Op0 = sub %X, %Y
let  %r = sub 0, %Y

*)
let alive_AddSub_1619 : forall (w : pos) (Y X : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := pair:%v4 %v1;
  %v6 := op:sub w %v5
  dsl_ret %v6 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (0) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6
  dsl_ret %v7)
 = ()

(* Name:AddSub:1624 *)
(* precondition: true *)
(*
let  %Op0 = or %A, %B
let  %Op1 = xor %A, %B
let  %r = sub %Op0, %Op1

=>
let  %Op0 = or %A, %B
let  %Op1 = xor %A, %B
let  %r = and %A, %B

*)
let alive_AddSub_1624 : forall (w : pos) (A B : BV.bv_t w)
,  assert(  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:sub w %v7
  dsl_ret %v8 ==   ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:and w %v7
  dsl_ret %v8)
 = ()