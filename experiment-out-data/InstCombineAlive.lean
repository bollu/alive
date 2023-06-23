import SSA.Core.WellTypedFramework
import SSA.Core.Tactic
import SSA.Projects.InstCombine.InstCombineBase
import SSA.Projects.InstCombine.Tactic

open SSA InstCombine EDSL


-- Name:RHS
-- precondition: true
/-
  %Y = and %Z, C1
  %X = xor %Y, C1
  %LHS = add %X, 1
  %r = add %LHS, %RHS

=>
  %or = or %Z, ~C1
  %Y = and %Z, C1
  %X = xor %Y, C1
  %LHS = add %X, 1
  %r = sub %RHS, %or

-/
theorem alive_RHS : forall (w : Nat) (C1 Z RHS : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Z) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:xor w %v5;
  %v7 := op:const (Bitvec.ofInt w (1)) %v0;
  %v8 := pair:%v6 %v7;
  %v9 := op:add w %v8;
  %v10 := op:const (RHS) %v0;
  %v11 := pair:%v9 %v10;
  %v12 := op:add w %v11
  dsl_ret %v12
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
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
  %v10 := op:const (Bitvec.ofInt w (1)) %v0;
  %v11 := pair:%v9 %v10;
  %v12 := op:add w %v11;
  %v13 := op:const (RHS) %v0;
  %v14 := pair:%v13 %v5;
  %v15 := op:sub w %v14
  dsl_ret %v15
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:x
-- precondition: true
/-
  %r = add i1 %x, %y

=>
  %r = xor %x, %y

-/
theorem alive_x: forall (y x : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add 1 %v3
  dsl_ret %v4
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor 1 %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %a = add %b, %b

=>
  %a = shl %b, 1

-/
theorem alive_b : forall (w : Nat) (b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := pair:%v1 %v1;
  %v3 := op:add w %v2
  dsl_ret %v3
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := op:const (Bitvec.ofInt w (1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %a = add nsw %b, %b

=>
  %a = shl nsw %b, 1

-/
theorem alive_b : forall (w : Nat) (b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := pair:%v1 %v1;
  %v3 := op:add w %v2
  dsl_ret %v3
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := op:const (Bitvec.ofInt w (1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %a = add nuw %b, %b

=>
  %a = shl nuw %b, 1

-/
theorem alive_b : forall (w : Nat) (b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := pair:%v1 %v1;
  %v3 := op:add w %v2
  dsl_ret %v3
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := op:const (Bitvec.ofInt w (1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %na = sub 0, %a
  %c = add %na, %b

=>
  %na = sub 0, %a
  %c = sub %b, %a

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (b) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:add w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (b) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %na = sub 0, %a
  %nb = sub 0, %b
  %c = add %na, %nb

=>
  %ab = add %a, %b
  %na = sub 0, %a
  %nb = sub 0, %b
  %c = sub 0, %ab

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := op:const (b) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:sub w %v7;
  %v9 := pair:%v4 %v8;
  %v10 := op:add w %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:sub w %v6;
  %v8 := op:const (Bitvec.ofInt w (0)) %v0;
  %v9 := pair:%v8 %v2;
  %v10 := op:sub w %v9;
  %v11 := op:const (Bitvec.ofInt w (0)) %v0;
  %v12 := pair:%v11 %v4;
  %v13 := op:sub w %v12
  dsl_ret %v13
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %nb = sub 0, %b
  %c = add %a, %nb

=>
  %nb = sub 0, %b
  %c = sub %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (a) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:add w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (a) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %nx = xor %x, -1
  %r = add %nx, C

=>
  %nx = xor %x, -1
  %r = sub (C - 1), %x

-/
theorem alive_C : forall (w : Nat) (x C : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:add w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := op:const (Bitvec.ofInt w (1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:sub w %v7;
  %v9 := pair:%v8 %v1;
  %v10 := op:sub w %v9
  dsl_ret %v10
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %aab = and %a, %b
  %aob = xor %a, %b
  %c = add %aab, %aob

=>
  %aab = and %a, %b
  %aob = xor %a, %b
  %c = or %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:add w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:or w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %lhs = and %a, %b
  %rhs = or %a, %b
  %c = add %lhs, %rhs

=>
  %lhs = and %a, %b
  %rhs = or %a, %b
  %c = add %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:add w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:add w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %lhs = and %a, %b
  %rhs = or %a, %b
  %c = add nsw %lhs, %rhs

=>
  %lhs = and %a, %b
  %rhs = or %a, %b
  %c = add nsw %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:add w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:add w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %lhs = and %a, %b
  %rhs = or %a, %b
  %c = add nuw %lhs, %rhs

=>
  %lhs = and %a, %b
  %rhs = or %a, %b
  %c = add nuw %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:add w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:add w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:x
-- precondition: true
/-
  %na = sub 0, %a
  %r = sub %x, %na

=>
  %na = sub 0, %a
  %r = add %x, %a

-/
theorem alive_x : forall (w : Nat) (a x : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (x) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:sub w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (x) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:add w %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %r = sub %x, C

=>
  %r = add %x, -C

-/
theorem alive_C : forall (w : Nat) (x C : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3
  dsl_ret %v4
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (C) %v0;
  %v3 := op:neg w %v2;
  %v4 := pair:%v1 %v3;
  %v5 := op:add w %v4
  dsl_ret %v5
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:x
-- precondition: true
/-
  %na = sub nsw 0, %a
  %r = sub nsw %x, %na

=>
  %na = sub nsw 0, %a
  %r = add nsw %x, %a

-/
theorem alive_x : forall (w : Nat) (a x : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (x) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:sub w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (x) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:add w %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:x
-- precondition: true
/-
  %r = sub i1 %x, %y

=>
  %r = xor %x, %y

-/
theorem alive_x: forall (y x : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub 1 %v3
  dsl_ret %v4
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor 1 %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:a
-- precondition: true
/-
  %r = sub -1, %a

=>
  %r = xor %a, -1

-/
theorem alive_a : forall (w : Nat) (a : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v2 := op:const (a) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3
  dsl_ret %v4
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %nx = xor %x, -1
  %r = sub C, %nx

=>
  %nx = xor %x, -1
  %r = add %x, (C + 1)

-/
theorem alive_C : forall (w : Nat) (x C : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:sub w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := op:const (Bitvec.ofInt w (1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:add w %v7;
  %v9 := pair:%v1 %v8;
  %v10 := op:add w %v9
  dsl_ret %v10
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C2
-- precondition: true
/-
  %rhs = add %X, C2
  %r = sub C, %rhs

=>
  %rhs = add %X, C2
  %r = sub (C - C2), %X

-/
theorem alive_C2 : forall (w : Nat) (X C C2 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C2) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:sub w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
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
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %Op1 = add %X, %Y
  %r = sub %X, %Op1

=>
  %Op1 = add %X, %Y
  %r = sub 0, %Y

-/
theorem alive_X : forall (w : Nat) (Y X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := pair:%v1 %v4;
  %v6 := op:sub w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %Op0 = sub %X, %Y
  %r = sub %Op0, %X

=>
  %Op0 = sub %X, %Y
  %r = sub 0, %Y

-/
theorem alive_X : forall (w : Nat) (Y X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := pair:%v4 %v1;
  %v6 := op:sub w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %Op0 = or %A, %B
  %Op1 = xor %A, %B
  %r = sub %Op0, %Op1

=>
  %Op0 = or %A, %B
  %Op1 = xor %A, %B
  %r = and %A, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:sub w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:and w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C2
-- precondition: true
/-
  %op = xor %X, C1
  %r = and %op, C2

=>
  %a = and %X, C2
  %op = xor %X, C1
  %r = xor %a, (C1 & C2)

-/
theorem alive_C2 : forall (w : Nat) (X C1 C2 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C2) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C2) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (C1) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v5 %v2;
  %v9 := op:and w %v8;
  %v10 := pair:%v4 %v9;
  %v11 := op:xor w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C2
-- precondition: true
/-
  %op = or %X, C1
  %r = and %op, C2

=>
  %o = or %X, (C1 & C2)
  %op = or %X, C1
  %r = and %o, C2

-/
theorem alive_C2 : forall (w : Nat) (X C1 C2 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (C2) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := op:const (C2) %v0;
  %v4 := pair:%v2 %v3;
  %v5 := op:and w %v4;
  %v6 := pair:%v1 %v5;
  %v7 := op:or w %v6;
  %v8 := pair:%v1 %v2;
  %v9 := op:or w %v8;
  %v10 := pair:%v7 %v3;
  %v11 := op:and w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:d
-- precondition: true
/-
  %a1 = and %a, %b
  %a2 = and %a, %d
  %op0 = icmp eq %a1, 0
  %op1 = icmp eq %a2, 0
  %r = and %op0, %op1

=>
  %or = or %b, %d
  %a3 = and %a, %or
  %a1 = and %a, %b
  %a2 = and %a, %d
  %op0 = icmp eq %a1, 0
  %op1 = icmp eq %a2, 0
  %r = icmp eq %a3, 0

-/
theorem alive_d : forall (w : Nat) (a b d : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (d) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:and w %v6;
  %v8 := op:const (Bitvec.ofInt w (0)) %v0;
  %v9 := pair:%v4 %v8;
  %v10 := op:icmp eq  w %v9;
  %v11 := op:const (Bitvec.ofInt w (0)) %v0;
  %v12 := pair:%v7 %v11;
  %v13 := op:icmp eq  w %v12;
  %v14 := pair:%v10 %v13;
  %v15 := op:and 1 %v14
  dsl_ret %v15
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := op:const (d) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (a) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:and w %v6;
  %v8 := pair:%v5 %v1;
  %v9 := op:and w %v8;
  %v10 := pair:%v5 %v2;
  %v11 := op:and w %v10;
  %v12 := op:const (Bitvec.ofInt w (0)) %v0;
  %v13 := pair:%v9 %v12;
  %v14 := op:icmp eq  w %v13;
  %v15 := op:const (Bitvec.ofInt w (0)) %v0;
  %v16 := pair:%v11 %v15;
  %v17 := op:icmp eq  w %v16;
  %v18 := op:const (Bitvec.ofInt w (0)) %v0;
  %v19 := pair:%v7 %v18;
  %v20 := op:icmp eq  w %v19
  dsl_ret %v20
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:d
-- precondition: true
/-
  %a1 = and %a, %b
  %a2 = and %a, %d
  %op0 = icmp eq %a1, %b
  %op1 = icmp eq %a2, %d
  %r = and %op0, %op1

=>
  %or = or %b, %d
  %a3 = and %a, %or
  %a1 = and %a, %b
  %a2 = and %a, %d
  %op0 = icmp eq %a1, %b
  %op1 = icmp eq %a2, %d
  %r = icmp eq %a3, %or

-/
theorem alive_d : forall (w : Nat) (a b d : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (d) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:and w %v6;
  %v8 := pair:%v4 %v2;
  %v9 := op:icmp eq  w %v8;
  %v10 := pair:%v7 %v5;
  %v11 := op:icmp eq  w %v10;
  %v12 := pair:%v9 %v11;
  %v13 := op:and 1 %v12
  dsl_ret %v13
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := op:const (d) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (a) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:and w %v6;
  %v8 := pair:%v5 %v1;
  %v9 := op:and w %v8;
  %v10 := pair:%v5 %v2;
  %v11 := op:and w %v10;
  %v12 := pair:%v9 %v1;
  %v13 := op:icmp eq  w %v12;
  %v14 := pair:%v11 %v2;
  %v15 := op:icmp eq  w %v14;
  %v16 := pair:%v7 %v4;
  %v17 := op:icmp eq  w %v16
  dsl_ret %v17
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:d
-- precondition: true
/-
  %a1 = and %a, %b
  %a2 = and %a, %d
  %op0 = icmp eq %a1, %a
  %op1 = icmp eq %a2, %a
  %r = and %op0, %op1

=>
  %a4 = and %b, %d
  %a3 = and %a, %a4
  %a1 = and %a, %b
  %a2 = and %a, %d
  %op0 = icmp eq %a1, %a
  %op1 = icmp eq %a2, %a
  %r = icmp eq %a3, %a

-/
theorem alive_d : forall (w : Nat) (a b d : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (d) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:and w %v6;
  %v8 := pair:%v4 %v1;
  %v9 := op:icmp eq  w %v8;
  %v10 := pair:%v7 %v1;
  %v11 := op:icmp eq  w %v10;
  %v12 := pair:%v9 %v11;
  %v13 := op:and 1 %v12
  dsl_ret %v13
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := op:const (d) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (a) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:and w %v6;
  %v8 := pair:%v5 %v1;
  %v9 := op:and w %v8;
  %v10 := pair:%v5 %v2;
  %v11 := op:and w %v10;
  %v12 := pair:%v9 %v5;
  %v13 := op:icmp eq  w %v12;
  %v14 := pair:%v11 %v5;
  %v15 := op:icmp eq  w %v14;
  %v16 := pair:%v7 %v5;
  %v17 := op:icmp eq  w %v16
  dsl_ret %v17
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %op0 = icmp sgt %a, %b
  %op1 = icmp ne %a, %b
  %r = and %op0, %op1

=>
  %op0 = icmp sgt %a, %b
  %op1 = icmp ne %a, %b
  %r = icmp sgt %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp sgt  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp ne  w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:and 1 %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp sgt  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp ne  w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:icmp sgt  w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %op0 = icmp eq %a, 0
  %op1 = icmp eq %b, 0
  %r = and %op0, %op1

=>
  %o = or %a, %b
  %op0 = icmp eq %a, 0
  %op1 = icmp eq %b, 0
  %r = icmp eq %o, 0

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt w (0)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp eq  w %v3;
  %v5 := op:const (b) %v0;
  %v6 := op:const (Bitvec.ofInt w (0)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:icmp eq  w %v7;
  %v9 := pair:%v4 %v8;
  %v10 := op:and 1 %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:icmp eq  w %v6;
  %v8 := op:const (Bitvec.ofInt w (0)) %v0;
  %v9 := pair:%v2 %v8;
  %v10 := op:icmp eq  w %v9;
  %v11 := op:const (Bitvec.ofInt w (0)) %v0;
  %v12 := pair:%v4 %v11;
  %v13 := op:icmp eq  w %v12
  dsl_ret %v13
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C1
-- precondition: true
/-
  %op0 = icmp eq %a, C1
  %op1 = icmp ne %a, C1
  %r = and %op0, %op1

=>
  %op0 = icmp eq %a, C1
  %op1 = icmp ne %a, C1
  %r = false

-/
theorem alive_C1 : forall (w : Nat) (a C1 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp eq  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp ne  w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:and 1 %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp eq  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp ne  w %v5;
  %v7 := op:const (Bitvec.ofBool false) %v0;
  %v8 := op:copy 1 %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:notOp1
-- precondition: true
/-
  %op0 = xor %notOp0, -1
  %op1 = xor %notOp1, -1
  %r = and %op0, %op1

=>
  %or = or %notOp0, %notOp1
  %op0 = xor %notOp0, -1
  %op1 = xor %notOp1, -1
  %r = xor %or, -1

-/
theorem alive_notOp1 : forall (w : Nat) (notOp0 notOp1 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (notOp0) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (notOp1) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v4 %v8;
  %v10 := op:and w %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (notOp0) %v0;
  %v2 := op:const (notOp1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:xor w %v6;
  %v8 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v9 := pair:%v2 %v8;
  %v10 := op:xor w %v9;
  %v11 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v12 := pair:%v4 %v11;
  %v13 := op:xor w %v12
  dsl_ret %v13
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %op0 = or %A, %B
  %notOp1 = and %A, %B
  %op1 = xor %notOp1, -1
  %r = and %op0, %op1

=>
  %op0 = or %A, %B
  %notOp1 = and %A, %B
  %op1 = xor %notOp1, -1
  %r = xor %A, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:and w %v5;
  %v7 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v8 := pair:%v6 %v7;
  %v9 := op:xor w %v8;
  %v10 := pair:%v4 %v9;
  %v11 := op:and w %v10
  dsl_ret %v11
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:and w %v5;
  %v7 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v8 := pair:%v6 %v7;
  %v9 := op:xor w %v8;
  %v10 := pair:%v1 %v2;
  %v11 := op:xor w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %notOp0 = and %A, %B
  %op0 = xor %notOp0, -1
  %op1 = or %A, %B
  %r = and %op0, %op1

=>
  %notOp0 = and %A, %B
  %op0 = xor %notOp0, -1
  %op1 = or %A, %B
  %r = xor %A, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v1 %v2;
  %v9 := op:or w %v8;
  %v10 := pair:%v7 %v9;
  %v11 := op:and w %v10
  dsl_ret %v11
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v1 %v2;
  %v9 := op:or w %v8;
  %v10 := pair:%v1 %v2;
  %v11 := op:xor w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %op0 = xor %A, %B
  %r = and %op0, %A

=>
  %notB = xor %B, -1
  %op0 = xor %A, %B
  %r = and %A, %notB

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := pair:%v4 %v1;
  %v6 := op:and w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (A) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:xor w %v6;
  %v8 := pair:%v5 %v4;
  %v9 := op:and w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %nA = xor %A, -1
  %op0 = or %nA, %B
  %r = and %op0, %A

=>
  %nA = xor %A, -1
  %op0 = or %nA, %B
  %r = and %A, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (B) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:or w %v6;
  %v8 := pair:%v7 %v1;
  %v9 := op:and w %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (B) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:or w %v6;
  %v8 := pair:%v1 %v5;
  %v9 := op:and w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %op0 = xor %A, %B
  %x = xor %B, %C
  %op1 = xor %x, %A
  %r = and %op0, %op1

=>
  %op0 = xor %A, %B
  %negC = xor %C, -1
  %x = xor %B, %C
  %op1 = xor %x, %A
  %r = and %op0, %negC

-/
theorem alive_B : forall (w : Nat) (A C B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v2 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v7 %v1;
  %v9 := op:xor w %v8;
  %v10 := pair:%v4 %v9;
  %v11 := op:and w %v10
  dsl_ret %v11
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v2 %v5;
  %v10 := op:xor w %v9;
  %v11 := pair:%v10 %v1;
  %v12 := op:xor w %v11;
  %v13 := pair:%v4 %v8;
  %v14 := op:and w %v13
  dsl_ret %v14
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %op0 = or %A, %B
  %x = xor %A, -1
  %op1 = xor %x, %B
  %r = and %op0, %op1

=>
  %op0 = or %A, %B
  %x = xor %A, -1
  %op1 = xor %x, %B
  %r = and %A, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v7 %v2;
  %v9 := op:xor w %v8;
  %v10 := pair:%v4 %v9;
  %v11 := op:and w %v10
  dsl_ret %v11
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v7 %v2;
  %v9 := op:xor w %v8;
  %v10 := pair:%v1 %v2;
  %v11 := op:and w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %op0 = icmp ugt %a, %b
  %op1 = icmp eq %a, %b
  %r = or %op0, %op1

=>
  %op0 = icmp ugt %a, %b
  %op1 = icmp eq %a, %b
  %r = icmp uge %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp ugt  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp eq  w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:or 1 %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp ugt  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp eq  w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:icmp uge  w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %op0 = icmp uge %a, %b
  %op1 = icmp ne %a, %b
  %r = or %op0, %op1

=>
  %op0 = icmp uge %a, %b
  %op1 = icmp ne %a, %b
  %r = true

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp uge  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp ne  w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:or 1 %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp uge  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp ne  w %v5;
  %v7 := op:const (Bitvec.ofBool true) %v0;
  %v8 := op:copy 1 %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %cmp1 = icmp eq %B, 0
  %cmp2 = icmp ult %A, %B
  %r = or %cmp1, %cmp2

=>
  %b1 = add %B, -1
  %cmp1 = icmp eq %B, 0
  %cmp2 = icmp ult %A, %B
  %r = icmp uge %b1, %A

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofInt w (0)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp eq  w %v3;
  %v5 := op:const (A) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:icmp ult  w %v6;
  %v8 := pair:%v4 %v7;
  %v9 := op:or 1 %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:icmp eq  w %v6;
  %v8 := op:const (A) %v0;
  %v9 := pair:%v8 %v1;
  %v10 := op:icmp ult  w %v9;
  %v11 := pair:%v4 %v8;
  %v12 := op:icmp uge  w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %cmp1 = icmp eq %B, 0
  %cmp2 = icmp ugt %B, %A
  %r = or %cmp1, %cmp2

=>
  %b1 = add %B, -1
  %cmp1 = icmp eq %B, 0
  %cmp2 = icmp ugt %B, %A
  %r = icmp uge %b1, %A

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofInt w (0)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp eq  w %v3;
  %v5 := op:const (A) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:icmp ugt  w %v6;
  %v8 := pair:%v4 %v7;
  %v9 := op:or 1 %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:icmp eq  w %v6;
  %v8 := op:const (A) %v0;
  %v9 := pair:%v1 %v8;
  %v10 := op:icmp ugt  w %v9;
  %v11 := pair:%v4 %v8;
  %v12 := op:icmp uge  w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %cmp1 = icmp ne %A, 0
  %cmp2 = icmp ne %B, 0
  %r = or %cmp1, %cmp2

=>
  %or = or %A, %B
  %cmp1 = icmp ne %A, 0
  %cmp2 = icmp ne %B, 0
  %r = icmp ne %or, 0

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (0)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp ne  w %v3;
  %v5 := op:const (B) %v0;
  %v6 := op:const (Bitvec.ofInt w (0)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:icmp ne  w %v7;
  %v9 := pair:%v4 %v8;
  %v10 := op:or 1 %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:icmp ne  w %v6;
  %v8 := op:const (Bitvec.ofInt w (0)) %v0;
  %v9 := pair:%v2 %v8;
  %v10 := op:icmp ne  w %v9;
  %v11 := op:const (Bitvec.ofInt w (0)) %v0;
  %v12 := pair:%v4 %v11;
  %v13 := op:icmp ne  w %v12
  dsl_ret %v13
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %op0 = xor %x, C1
  %r = or %op0, C

=>
  %or = or %x, C
  %op0 = xor %x, C1
  %r = xor %or, (C1 & ~C)

-/
theorem alive_C : forall (w : Nat) (x C1 C : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:or w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (C1) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:xor w %v6;
  %v8 := op:not w %v2;
  %v9 := pair:%v5 %v8;
  %v10 := op:and w %v9;
  %v11 := pair:%v4 %v10;
  %v12 := op:xor w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %negA = xor %A, -1
  %op0 = and %negA, %B
  %r = or %op0, %A

=>
  %negA = xor %A, -1
  %op0 = and %negA, %B
  %r = or %A, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (B) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and w %v6;
  %v8 := pair:%v7 %v1;
  %v9 := op:or w %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (B) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and w %v6;
  %v8 := pair:%v1 %v5;
  %v9 := op:or w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %negA = xor %A, -1
  %op0 = and %A, %B
  %r = or %op0, %negA

=>
  %negA = xor %A, -1
  %op0 = and %A, %B
  %r = or %negA, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (B) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:and w %v6;
  %v8 := pair:%v7 %v4;
  %v9 := op:or w %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (B) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:and w %v6;
  %v8 := pair:%v4 %v5;
  %v9 := op:or w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %negB = xor %B, -1
  %op0 = and %A, %negB
  %op1 = xor %A, %B
  %r = or %op0, %op1

=>
  %negB = xor %B, -1
  %op0 = and %A, %negB
  %op1 = xor %A, %B
  %r = xor %A, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (A) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:and w %v6;
  %v8 := pair:%v5 %v1;
  %v9 := op:xor w %v8;
  %v10 := pair:%v7 %v9;
  %v11 := op:or w %v10
  dsl_ret %v11
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (A) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:and w %v6;
  %v8 := pair:%v5 %v1;
  %v9 := op:xor w %v8;
  %v10 := pair:%v5 %v1;
  %v11 := op:xor w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:D
-- precondition: true
/-
  %C = xor %D, -1
  %B = xor %A, -1
  %op0 = and %A, %C
  %op1 = and %B, %D
  %r = or %op0, %op1

=>
  %C = xor %D, -1
  %B = xor %A, -1
  %op0 = and %A, %C
  %op1 = and %B, %D
  %r = xor %A, %D

-/
theorem alive_D : forall (w : Nat) (A D : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (D) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (A) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v5 %v4;
  %v10 := op:and w %v9;
  %v11 := pair:%v8 %v1;
  %v12 := op:and w %v11;
  %v13 := pair:%v10 %v12;
  %v14 := op:or w %v13
  dsl_ret %v14
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (D) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (A) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v5 %v4;
  %v10 := op:and w %v9;
  %v11 := pair:%v8 %v1;
  %v12 := op:and w %v11;
  %v13 := pair:%v5 %v1;
  %v14 := op:xor w %v13
  dsl_ret %v14
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %op0 = xor %A, %B
  %x = xor %B, %C
  %op1 = xor %x, %A
  %r = or %op0, %op1

=>
  %op0 = xor %A, %B
  %x = xor %B, %C
  %op1 = xor %x, %A
  %r = or %op0, %C

-/
theorem alive_B : forall (w : Nat) (A C B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v2 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v7 %v1;
  %v9 := op:xor w %v8;
  %v10 := pair:%v4 %v9;
  %v11 := op:or w %v10
  dsl_ret %v11
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v2 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v7 %v1;
  %v9 := op:xor w %v8;
  %v10 := pair:%v4 %v5;
  %v11 := op:or w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %o = or %B, %C
  %op0 = and %o, %A
  %r = or %op0, %B

=>
  %a = and %A, %C
  %o = or %B, %C
  %op0 = and %o, %A
  %r = or %B, %a

-/
theorem alive_B : forall (w : Nat) (A C B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (A) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and w %v6;
  %v8 := pair:%v7 %v1;
  %v9 := op:or w %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (B) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:or w %v6;
  %v8 := pair:%v7 %v1;
  %v9 := op:and w %v8;
  %v10 := pair:%v5 %v4;
  %v11 := op:or w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %na = xor %A, -1
  %nb = xor %B, -1
  %r = or %na, %nb

=>
  %a = and %A, %B
  %na = xor %A, -1
  %nb = xor %B, -1
  %r = xor %a, -1

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (B) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v4 %v8;
  %v10 := op:or w %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:xor w %v6;
  %v8 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v9 := pair:%v2 %v8;
  %v10 := op:xor w %v9;
  %v11 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v12 := pair:%v4 %v11;
  %v13 := op:xor w %v12
  dsl_ret %v13
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:op0
-- precondition: true
/-
  %op1 = xor %op0, %B
  %r = or %op0, %op1

=>
  %op1 = xor %op0, %B
  %r = or %op0, %B

-/
theorem alive_op0 : forall (w : Nat) (B op0 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (op0) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := pair:%v1 %v4;
  %v6 := op:or w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (op0) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5
  dsl_ret %v6
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %na = xor %A, -1
  %op1 = xor %na, %B
  %r = or %A, %op1

=>
  %nb = xor %B, -1
  %na = xor %A, -1
  %op1 = xor %na, %B
  %r = or %A, %nb

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (B) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v1 %v7;
  %v9 := op:or w %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (A) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v8 %v1;
  %v10 := op:xor w %v9;
  %v11 := pair:%v5 %v4;
  %v12 := op:or w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %op0 = and %A, %B
  %op1 = xor %A, %B
  %r = or %op0, %op1

=>
  %op0 = and %A, %B
  %op1 = xor %A, %B
  %r = or %A, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:or w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:or w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %o = or %A, %B
  %op1 = xor %o, -1
  %r = or %A, %op1

=>
  %not = xor %B, -1
  %o = or %A, %B
  %op1 = xor %o, -1
  %r = or %A, %not

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v1 %v7;
  %v9 := op:or w %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (A) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:or w %v6;
  %v8 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v9 := pair:%v7 %v8;
  %v10 := op:xor w %v9;
  %v11 := pair:%v5 %v4;
  %v12 := op:or w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %o = xor %A, %B
  %op1 = xor %o, -1
  %r = or %A, %op1

=>
  %not = xor %B, -1
  %o = xor %A, %B
  %op1 = xor %o, -1
  %r = or %A, %not

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v1 %v7;
  %v9 := op:or w %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (A) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:xor w %v6;
  %v8 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v9 := pair:%v7 %v8;
  %v10 := op:xor w %v9;
  %v11 := pair:%v5 %v4;
  %v12 := op:or w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %op0 = and %A, %B
  %na = xor %A, -1
  %op1 = xor %na, %B
  %r = or %op0, %op1

=>
  %na = xor %A, -1
  %op0 = and %A, %B
  %op1 = xor %na, %B
  %r = xor %na, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v7 %v2;
  %v9 := op:xor w %v8;
  %v10 := pair:%v4 %v9;
  %v11 := op:or w %v10
  dsl_ret %v11
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (B) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:and w %v6;
  %v8 := pair:%v4 %v5;
  %v9 := op:xor w %v8;
  %v10 := pair:%v4 %v5;
  %v11 := op:xor w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:op1
-- precondition: true
/-
  %op0 = or %A, C1
  %r = or %op0, %op1

=>
  %i = or %A, %op1
  %op0 = or %A, C1
  %r = or %i, C1

-/
theorem alive_op1 : forall (w : Nat) (A C1 op1 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (op1) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:or w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (op1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (C1) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:or w %v6;
  %v8 := pair:%v4 %v5;
  %v9 := op:or w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:D
-- precondition: true
/-
  %op0 = select i1 %x, %A, %B
  %op1 = select i1 %x, %C, %D
  %r = or %op0, %op1

=>
  %t = or %A, %C
  %f = or %B, %D
  %op0 = select i1 %x, %A, %B
  %op1 = select i1 %x, %C, %D
  %r = select i1 %x, %t, %f

-/
theorem alive_D : forall (w : Nat) (A x C B D : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (A) %v0;
  %v3 := op:const (B) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select w %v4;
  %v6 := op:const (C) %v0;
  %v7 := op:const (D) %v0;
  %v8 := triple:%v1 %v6 %v7;
  %v9 := op:select w %v8;
  %v10 := pair:%v5 %v9;
  %v11 := op:or w %v10
  dsl_ret %v11
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or 1 %v3;
  %v5 := op:const (B) %v0;
  %v6 := op:const (D) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:or 1 %v7;
  %v9 := op:const (x) %v0;
  %v10 := triple:%v9 %v1 %v5;
  %v11 := op:select 1 %v10;
  %v12 := triple:%v9 %v2 %v6;
  %v13 := op:select 1 %v12;
  %v14 := triple:%v9 %v4 %v8;
  %v15 := op:select 1 %v14
  dsl_ret %v15
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:y
-- precondition: true
/-
  %x = xor %nx, -1
  %op0 = and %x, %y
  %r = xor %op0, -1

=>
  %ny = xor %y, -1
  %x = xor %nx, -1
  %op0 = and %x, %y
  %r = or %nx, %ny

-/
theorem alive_y : forall (w : Nat) (nx y : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (nx) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (y) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and w %v6;
  %v8 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v9 := pair:%v7 %v8;
  %v10 := op:xor w %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (y) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (nx) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v8 %v1;
  %v10 := op:and w %v9;
  %v11 := pair:%v5 %v4;
  %v12 := op:or w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:y
-- precondition: true
/-
  %x = xor %nx, -1
  %op0 = or %x, %y
  %r = xor %op0, -1

=>
  %ny = xor %y, -1
  %x = xor %nx, -1
  %op0 = or %x, %y
  %r = and %nx, %ny

-/
theorem alive_y : forall (w : Nat) (nx y : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (nx) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (y) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:or w %v6;
  %v8 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v9 := pair:%v7 %v8;
  %v10 := op:xor w %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (y) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (nx) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v8 %v1;
  %v10 := op:or w %v9;
  %v11 := pair:%v5 %v4;
  %v12 := op:and w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:x
-- precondition: true
/-
  %op0 = and %x, %y
  %r = xor %op0, -1

=>
  %nx = xor %x, -1
  %ny = xor %y, -1
  %op0 = and %x, %y
  %r = or %nx, %ny

-/
theorem alive_x : forall (w : Nat) (y x : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:xor w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (y) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v1 %v5;
  %v10 := op:and w %v9;
  %v11 := pair:%v4 %v8;
  %v12 := op:or w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:x
-- precondition: true
/-
  %op0 = or %x, %y
  %r = xor %op0, -1

=>
  %nx = xor %x, -1
  %ny = xor %y, -1
  %op0 = or %x, %y
  %r = and %nx, %ny

-/
theorem alive_x : forall (w : Nat) (y x : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:xor w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (y) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v1 %v5;
  %v10 := op:or w %v9;
  %v11 := pair:%v4 %v8;
  %v12 := op:and w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:x
-- precondition: true
/-
  %nx = xor %x, -1
  %op0 = ashr %nx, %y
  %r = xor %op0, -1

=>
  %nx = xor %x, -1
  %op0 = ashr %nx, %y
  %r = ashr %x, %y

-/
theorem alive_x : forall (w : Nat) (y x : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (y) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:ashr w %v6;
  %v8 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v9 := pair:%v7 %v8;
  %v10 := op:xor w %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (y) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:ashr w %v6;
  %v8 := pair:%v1 %v5;
  %v9 := op:ashr w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:x
-- precondition: true
/-
  %op0 = icmp slt %x, %y
  %r = xor %op0, -1

=>
  %op0 = icmp slt %x, %y
  %r = icmp sge %x, %y

-/
theorem alive_x : forall (w : Nat) (y x : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp slt  w %v3;
  %v5 := op:const (Bitvec.ofInt 1 (-1)) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:xor 1 %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp slt  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp sge  w %v5
  dsl_ret %v6
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %op0 = sub C, %x
  %r = xor %op0, -1

=>
  %op0 = sub C, %x
  %r = add %x, (-1 - C)

-/
theorem alive_C : forall (w : Nat) (x C : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (C) %v0;
  %v2 := op:const (x) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:xor w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (C) %v0;
  %v2 := op:const (x) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:sub w %v6;
  %v8 := pair:%v2 %v7;
  %v9 := op:add w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %op0 = add %x, C
  %r = xor %op0, -1

=>
  %op0 = add %x, C
  %r = sub (-1 - C), %x

-/
theorem alive_C : forall (w : Nat) (x C : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:xor w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6;
  %v8 := pair:%v7 %v1;
  %v9 := op:sub w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:op1
-- precondition: true
/-
  %op0 = or %a, %op1
  %r = xor %op0, %op1

=>
  %nop1 = xor %op1, -1
  %op0 = or %a, %op1
  %r = and %a, %nop1

-/
theorem alive_op1 : forall (w : Nat) (a op1 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (op1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or w %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:xor w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (op1) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (a) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:or w %v6;
  %v8 := pair:%v5 %v4;
  %v9 := op:and w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:op1
-- precondition: true
/-
  %op0 = and %a, %op1
  %r = xor %op0, %op1

=>
  %na = xor %a, -1
  %op0 = and %a, %op1
  %r = and %na, %op1

-/
theorem alive_op1 : forall (w : Nat) (a op1 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (op1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:xor w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (op1) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:and w %v6;
  %v8 := pair:%v4 %v5;
  %v9 := op:and w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %op0 = and %a, %b
  %op1 = or %a, %b
  %r = xor %op0, %op1

=>
  %op0 = and %a, %b
  %op1 = or %a, %b
  %r = xor %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:xor w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:or w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:xor w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %na = xor %a, -1
  %nb = xor %b, -1
  %op0 = or %a, %nb
  %op1 = or %na, %b
  %r = xor %op0, %op1

=>
  %na = xor %a, -1
  %nb = xor %b, -1
  %op0 = or %a, %nb
  %op1 = or %na, %b
  %r = xor %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (b) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v1 %v8;
  %v10 := op:or w %v9;
  %v11 := pair:%v4 %v5;
  %v12 := op:or w %v11;
  %v13 := pair:%v10 %v12;
  %v14 := op:xor w %v13
  dsl_ret %v14
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (b) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v1 %v8;
  %v10 := op:or w %v9;
  %v11 := pair:%v4 %v5;
  %v12 := op:or w %v11;
  %v13 := pair:%v1 %v5;
  %v14 := op:xor w %v13
  dsl_ret %v14
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %na = xor %a, -1
  %nb = xor %b, -1
  %op0 = and %a, %nb
  %op1 = and %na, %b
  %r = xor %op0, %op1

=>
  %na = xor %a, -1
  %nb = xor %b, -1
  %op0 = and %a, %nb
  %op1 = and %na, %b
  %r = xor %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (b) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v1 %v8;
  %v10 := op:and w %v9;
  %v11 := pair:%v4 %v5;
  %v12 := op:and w %v11;
  %v13 := pair:%v10 %v12;
  %v14 := op:xor w %v13
  dsl_ret %v14
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (b) %v0;
  %v6 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:xor w %v7;
  %v9 := pair:%v1 %v8;
  %v10 := op:and w %v9;
  %v11 := pair:%v4 %v5;
  %v12 := op:and w %v11;
  %v13 := pair:%v1 %v5;
  %v14 := op:xor w %v13
  dsl_ret %v14
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %op0 = xor %a, %c
  %op1 = or %a, %b
  %r = xor %op0, %op1

=>
  %na = xor %a, -1
  %and = and %na, %b
  %op0 = xor %a, %c
  %op1 = or %a, %b
  %r = xor %and, %c

-/
theorem alive_b : forall (w : Nat) (a c b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (c) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (b) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:or w %v6;
  %v8 := pair:%v4 %v7;
  %v9 := op:xor w %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (b) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and w %v6;
  %v8 := op:const (c) %v0;
  %v9 := pair:%v1 %v8;
  %v10 := op:xor w %v9;
  %v11 := pair:%v1 %v5;
  %v12 := op:or w %v11;
  %v13 := pair:%v7 %v8;
  %v14 := op:xor w %v13
  dsl_ret %v14
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %op0 = and %a, %b
  %op1 = xor %a, %b
  %r = xor %op0, %op1

=>
  %op0 = and %a, %b
  %op1 = xor %a, %b
  %r = or %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:xor w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:xor w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:or w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %nb = xor %b, -1
  %op0 = and %a, %nb
  %na = xor %a, -1
  %r = xor %op0, %na

=>
  %and = and %a, %b
  %nb = xor %b, -1
  %op0 = and %a, %nb
  %na = xor %a, -1
  %r = xor %and, -1

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (b) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (a) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:and w %v6;
  %v8 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v9 := pair:%v5 %v8;
  %v10 := op:xor w %v9;
  %v11 := pair:%v7 %v10;
  %v12 := op:xor w %v11
  dsl_ret %v12
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v2 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v1 %v7;
  %v9 := op:and w %v8;
  %v10 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v11 := pair:%v1 %v10;
  %v12 := op:xor w %v11;
  %v13 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v14 := pair:%v4 %v13;
  %v15 := op:xor w %v14
  dsl_ret %v15
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %op0 = icmp ule %a, %b
  %op1 = icmp ne %a, %b
  %r = xor %op0, %op1

=>
  %op0 = icmp ule %a, %b
  %op1 = icmp ne %a, %b
  %r = icmp uge %a, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp ule  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp ne  w %v5;
  %v7 := pair:%v4 %v6;
  %v8 := op:xor 1 %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp ule  w %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:icmp ne  w %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:icmp uge  w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:x
-- precondition: true
/-
  %r = mul %x, -1

=>
  %r = sub 0, %x

-/
theorem alive_x : forall (w : Nat) (x : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:mul w %v3
  dsl_ret %v4
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (x) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C2
-- precondition: true
/-
  %sh = shl i7 %x, C2
  %r = mul %sh, C1

=>
  %sh = shl i7 %x, C2
  %r = mul %x, (C1 << C2)

-/
theorem alive_C2: forall (x C1 C2 : Bitvec 7)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 7)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (C2) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 7 %v3;
  %v5 := op:const (C1) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:mul 7 %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 7)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (C2) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 7 %v3;
  %v5 := op:const (C1) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:shl 7 %v6;
  %v8 := pair:%v1 %v7;
  %v9 := op:mul 7 %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:Op1
-- precondition: true
/-
  %Op0 = add %X, C1
  %r = mul %Op0, %Op1

=>
  %mul = mul C1, %Op1
  %tmp = mul %X, %Op1
  %Op0 = add %X, C1
  %r = add %tmp, %mul

-/
theorem alive_Op1 : forall (w : Nat) (X C1 Op1 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (Op1) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:mul w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (C1) %v0;
  %v2 := op:const (Op1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:mul w %v3;
  %v5 := op:const (X) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:mul w %v6;
  %v8 := pair:%v5 %v1;
  %v9 := op:add w %v8;
  %v10 := pair:%v7 %v4;
  %v11 := op:add w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %a = sub 0, %X
  %b = sub 0, %Y
  %r = mul %a, %b

=>
  %a = sub 0, %X
  %b = sub 0, %Y
  %r = mul %X, %Y

-/
theorem alive_X : forall (w : Nat) (Y X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (X) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := op:const (Y) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:sub w %v7;
  %v9 := pair:%v4 %v8;
  %v10 := op:mul w %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (X) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := op:const (Y) %v0;
  %v7 := pair:%v5 %v6;
  %v8 := op:sub w %v7;
  %v9 := pair:%v2 %v6;
  %v10 := op:mul w %v9
  dsl_ret %v10
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %div = udiv exact %X, %Y
  %r = mul %div, %Y

=>
  %div = udiv exact %X, %Y
  %r = %X

-/
theorem alive_X : forall (w : Nat) (Y X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:udiv w %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:mul w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:udiv w %v3;
  %v5 := op:copy w %v1
  dsl_ret %v5
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %div = sdiv exact %X, %Y
  %r = mul %div, %Y

=>
  %div = sdiv exact %X, %Y
  %r = %X

-/
theorem alive_X : forall (w : Nat) (Y X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sdiv w %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:mul w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sdiv w %v3;
  %v5 := op:copy w %v1
  dsl_ret %v5
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %div = udiv exact %X, %Y
  %negY = sub 0, %Y
  %r = mul %div, %negY

=>
  %div = udiv exact %X, %Y
  %negY = sub 0, %Y
  %r = sub 0, %X

-/
theorem alive_X : forall (w : Nat) (Y X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:udiv w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6;
  %v8 := pair:%v4 %v7;
  %v9 := op:mul w %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:udiv w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6;
  %v8 := op:const (Bitvec.ofInt w (0)) %v0;
  %v9 := pair:%v8 %v1;
  %v10 := op:sub w %v9
  dsl_ret %v10
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %div = sdiv exact %X, %Y
  %negY = sub 0, %Y
  %r = mul %div, %negY

=>
  %div = sdiv exact %X, %Y
  %negY = sub 0, %Y
  %r = sub 0, %X

-/
theorem alive_X : forall (w : Nat) (Y X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sdiv w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6;
  %v8 := pair:%v4 %v7;
  %v9 := op:mul w %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sdiv w %v3;
  %v5 := op:const (Bitvec.ofInt w (0)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub w %v6;
  %v8 := op:const (Bitvec.ofInt w (0)) %v0;
  %v9 := pair:%v8 %v1;
  %v10 := op:sub w %v9
  dsl_ret %v10
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %div = udiv i5 %X, %Y
  %r = mul %div, %Y

=>
  %rem = urem %X, %Y
  %div = udiv i5 %X, %Y
  %r = sub %X, %rem

-/
theorem alive_X: forall (Y X : Bitvec 5)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 5)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:udiv 5 %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:mul 5 %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 5)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:urem 5 %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:udiv 5 %v5;
  %v7 := pair:%v1 %v4;
  %v8 := op:sub 5 %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %div = sdiv i5 %X, %Y
  %r = mul %div, %Y

=>
  %rem = srem %X, %Y
  %div = sdiv i5 %X, %Y
  %r = sub %X, %rem

-/
theorem alive_X: forall (Y X : Bitvec 5)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 5)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sdiv 5 %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:mul 5 %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 5)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:srem 5 %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:sdiv 5 %v5;
  %v7 := pair:%v1 %v4;
  %v8 := op:sub 5 %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %div = sdiv i5 %X, %Y
  %negY = sub 0, %Y
  %r = mul %div, %negY

=>
  %rem = srem %X, %Y
  %div = sdiv i5 %X, %Y
  %negY = sub 0, %Y
  %r = sub %rem, %X

-/
theorem alive_X: forall (Y X : Bitvec 5)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 5)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sdiv 5 %v3;
  %v5 := op:const (Bitvec.ofInt 5 (0)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub 5 %v6;
  %v8 := pair:%v4 %v7;
  %v9 := op:mul 5 %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 5)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:srem 5 %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:sdiv 5 %v5;
  %v7 := op:const (Bitvec.ofInt 5 (0)) %v0;
  %v8 := pair:%v7 %v2;
  %v9 := op:sub 5 %v8;
  %v10 := pair:%v4 %v1;
  %v11 := op:sub 5 %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %div = udiv i5 %X, %Y
  %negY = sub 0, %Y
  %r = mul %div, %negY

=>
  %rem = urem %X, %Y
  %div = udiv i5 %X, %Y
  %negY = sub 0, %Y
  %r = sub %rem, %X

-/
theorem alive_X: forall (Y X : Bitvec 5)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 5)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:udiv 5 %v3;
  %v5 := op:const (Bitvec.ofInt 5 (0)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:sub 5 %v6;
  %v8 := pair:%v4 %v7;
  %v9 := op:mul 5 %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 5)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:urem 5 %v3;
  %v5 := pair:%v1 %v2;
  %v6 := op:udiv 5 %v5;
  %v7 := op:const (Bitvec.ofInt 5 (0)) %v0;
  %v8 := pair:%v7 %v2;
  %v9 := op:sub 5 %v8;
  %v10 := pair:%v4 %v1;
  %v11 := op:sub 5 %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %r = mul i1 %X, %Y

=>
  %r = and %X, %Y

-/
theorem alive_X: forall (Y X : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:mul 1 %v3
  dsl_ret %v4
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and 1 %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:Op1
-- precondition: true
/-
  %Op0 = shl 1, %Y
  %r = mul %Op0, %Op1

=>
  %Op0 = shl 1, %Y
  %r = shl %Op1, %Y

-/
theorem alive_Op1 : forall (w : Nat) (Y Op1 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (1)) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3;
  %v5 := op:const (Op1) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:mul w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (1)) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3;
  %v5 := op:const (Op1) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:shl w %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:c
-- precondition: true
/-
  %sel = select i1 %c, %Y, 0
  %r = udiv %X, %sel

=>
  %sel = select i1 %c, %Y, 0
  %r = udiv %X, %Y

-/
theorem alive_c : forall (w : Nat) (Y X c : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (c) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select w %v4;
  %v6 := op:const (X) %v0;
  %v7 := pair:%v6 %v5;
  %v8 := op:udiv w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (c) %v0;
  %v2 := op:const (Y) %v0;
  %v3 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select 1 %v4;
  %v6 := op:const (X) %v0;
  %v7 := pair:%v6 %v2;
  %v8 := op:udiv 1 %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %r = sdiv 1, %X

=>
  %inc = add %X, 1
  %c = icmp ult %inc, 3
  %r = select i1 %c, %X, 0

-/
theorem alive_X : forall (w : Nat) (X : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (1)) %v0;
  %v2 := op:const (X) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sdiv w %v3
  dsl_ret %v4
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Bitvec.ofInt w (1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (Bitvec.ofInt w (3)) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:icmp ult  w %v6;
  %v8 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v9 := triple:%v7 %v1 %v8;
  %v10 := op:select w %v9
  dsl_ret %v10
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:Op1
-- precondition: true
/-
  %Z = srem i9 %X, %Op1
  %Op0 = sub %X, %Z
  %r = sdiv %Op0, %Op1

=>
  %Z = srem i9 %X, %Op1
  %Op0 = sub %X, %Z
  %r = sdiv %X, %Op1

-/
theorem alive_Op1: forall (X Op1 : Bitvec 9)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 9)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Op1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:srem 9 %v3;
  %v5 := pair:%v1 %v4;
  %v6 := op:sub 9 %v5;
  %v7 := pair:%v6 %v2;
  %v8 := op:sdiv 9 %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 9)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Op1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:srem 9 %v3;
  %v5 := pair:%v1 %v4;
  %v6 := op:sub 9 %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:sdiv 9 %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:Op1
-- precondition: true
/-
  %Z = urem i9 %X, %Op1
  %Op0 = sub %X, %Z
  %r = udiv %Op0, %Op1

=>
  %Z = urem i9 %X, %Op1
  %Op0 = sub %X, %Z
  %r = udiv %X, %Op1

-/
theorem alive_Op1: forall (X Op1 : Bitvec 9)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 9)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Op1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:urem 9 %v3;
  %v5 := pair:%v1 %v4;
  %v6 := op:sub 9 %v5;
  %v7 := pair:%v6 %v2;
  %v8 := op:udiv 9 %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 9)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Op1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:urem 9 %v3;
  %v5 := pair:%v1 %v4;
  %v6 := op:sub 9 %v5;
  %v7 := pair:%v1 %v2;
  %v8 := op:udiv 9 %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:N
-- precondition: true
/-
  %s = shl i13 1, %N
  %r = udiv %x, %s

=>
  %s = shl i13 1, %N
  %r = lshr %x, %N

-/
theorem alive_N: forall (x N : Bitvec 13)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 13)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt 13 (1)) %v0;
  %v2 := op:const (N) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 13 %v3;
  %v5 := op:const (x) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:udiv 13 %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 13)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt 13 (1)) %v0;
  %v2 := op:const (N) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 13 %v3;
  %v5 := op:const (x) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:lshr 13 %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:N
-- precondition: true
/-
  %s = shl i13 1, %N
  %r = udiv exact %x, %s

=>
  %s = shl i13 1, %N
  %r = lshr exact %x, %N

-/
theorem alive_N: forall (x N : Bitvec 13)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 13)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt 13 (1)) %v0;
  %v2 := op:const (N) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 13 %v3;
  %v5 := op:const (x) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:udiv 13 %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 13)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt 13 (1)) %v0;
  %v2 := op:const (N) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 13 %v3;
  %v5 := op:const (x) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:lshr 13 %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %r = sdiv %X, -1

=>
  %r = sub 0, %X

-/
theorem alive_X : forall (w : Nat) (X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sdiv w %v3
  dsl_ret %v4
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt w (0)) %v0;
  %v2 := op:const (X) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub w %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %Op0 = sub nsw i11 0, %X
  %r = sdiv %Op0, C

=>
  %Op0 = sub nsw i11 0, %X
  %r = sdiv %X, -C

-/
theorem alive_C: forall (X C : Bitvec 11)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 11)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt 11 (0)) %v0;
  %v2 := op:const (X) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub 11 %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:sdiv 11 %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 11)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt 11 (0)) %v0;
  %v2 := op:const (X) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub 11 %v3;
  %v5 := op:const (C) %v0;
  %v6 := op:neg 11 %v5;
  %v7 := pair:%v2 %v6;
  %v8 := op:sdiv 11 %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %c = icmp eq %X, C
  %r = select i1 %c, %X, %Y

=>
  %c = icmp eq %X, C
  %r = select i1 %c, C, %Y

-/
theorem alive_X : forall (w : Nat) (Y C : Bitvec 1)
(X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp eq  w %v3;
  %v5 := op:const (Y) %v0;
  %v6 := triple:%v4 %v1 %v5;
  %v7 := op:select w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp eq  w %v3;
  %v5 := op:const (Y) %v0;
  %v6 := triple:%v4 %v2 %v5;
  %v7 := op:select w %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %c = icmp ne %X, C
  %r = select i1 %c, %Y, %X

=>
  %c = icmp ne %X, C
  %r = select i1 %c, %Y, C

-/
theorem alive_X : forall (w : Nat) (Y C : Bitvec 1)
(X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp ne  w %v3;
  %v5 := op:const (Y) %v0;
  %v6 := triple:%v4 %v5 %v1;
  %v7 := op:select w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp ne  w %v3;
  %v5 := op:const (Y) %v0;
  %v6 := triple:%v4 %v5 %v2;
  %v7 := op:select w %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %c = icmp uge %A, %B
  %umax = select i1 %c, %A, %B
  %c2 = icmp uge %umax, %B
  %umax2 = select i1 %c2, %umax, %B

=>
  %c = icmp uge %A, %B
  %umax = select i1 %c, %A, %B
  %c2 = icmp uge %umax, %B
  %umax2 = select i1 %c, %A, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp uge  w %v3;
  %v5 := triple:%v4 %v1 %v2;
  %v6 := op:select 1 %v5;
  %v7 := pair:%v6 %v2;
  %v8 := op:icmp uge  w %v7;
  %v9 := triple:%v8 %v6 %v2;
  %v10 := op:select 1 %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp uge  1 %v3;
  %v5 := triple:%v4 %v1 %v2;
  %v6 := op:select 1 %v5;
  %v7 := pair:%v6 %v2;
  %v8 := op:icmp uge  1 %v7;
  %v9 := triple:%v4 %v1 %v2;
  %v10 := op:select 1 %v9
  dsl_ret %v10
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %c = icmp slt %A, %B
  %smin = select i1 %c, %A, %B
  %c2 = icmp slt %smin, %B
  %smin2 = select i1 %c2, %smin, %B

=>
  %c = icmp slt %A, %B
  %smin = select i1 %c, %A, %B
  %c2 = icmp slt %smin, %B
  %smin2 = select i1 %c, %A, %B

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp slt  w %v3;
  %v5 := triple:%v4 %v1 %v2;
  %v6 := op:select 1 %v5;
  %v7 := pair:%v6 %v2;
  %v8 := op:icmp slt  w %v7;
  %v9 := triple:%v8 %v6 %v2;
  %v10 := op:select 1 %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp slt  1 %v3;
  %v5 := triple:%v4 %v1 %v2;
  %v6 := op:select 1 %v5;
  %v7 := pair:%v6 %v2;
  %v8 := op:icmp slt  1 %v7;
  %v9 := triple:%v4 %v1 %v2;
  %v10 := op:select 1 %v9
  dsl_ret %v10
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %c = icmp slt %A, %B
  %smin = select i1 %c, %A, %B
  %c2 = icmp sge %smin, %A
  %smax = select i1 %c2, %smin, %A

=>
  %c = icmp slt %A, %B
  %smin = select i1 %c, %A, %B
  %c2 = icmp sge %smin, %A
  %smax = %A

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp slt  w %v3;
  %v5 := triple:%v4 %v1 %v2;
  %v6 := op:select 1 %v5;
  %v7 := pair:%v6 %v1;
  %v8 := op:icmp sge  w %v7;
  %v9 := triple:%v8 %v6 %v1;
  %v10 := op:select 1 %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp slt  1 %v3;
  %v5 := triple:%v4 %v1 %v2;
  %v6 := op:select 1 %v5;
  %v7 := pair:%v6 %v1;
  %v8 := op:icmp sge  1 %v7;
  %v9 := op:copy 1 %v1
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %c = icmp sge %A, %B
  %umax = select i1 %c, %A, %B
  %c2 = icmp slt %umax, %A
  %umin = select i1 %c2, %umax, %A

=>
  %c = icmp sge %A, %B
  %umax = select i1 %c, %A, %B
  %c2 = icmp slt %umax, %A
  %umin = %A

-/
theorem alive_B : forall (w : Nat) (A B : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp sge  w %v3;
  %v5 := triple:%v4 %v1 %v2;
  %v6 := op:select 1 %v5;
  %v7 := pair:%v6 %v1;
  %v8 := op:icmp slt  w %v7;
  %v9 := triple:%v8 %v6 %v1;
  %v10 := op:select 1 %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (B) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp sge  1 %v3;
  %v5 := triple:%v4 %v1 %v2;
  %v6 := op:select 1 %v5;
  %v7 := pair:%v6 %v1;
  %v8 := op:icmp slt  1 %v7;
  %v9 := op:copy 1 %v1
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:A
-- precondition: true
/-
  %c = icmp sgt %A, 0
  %minus = sub 0, %A
  %abs = select i1 %c, %A, %minus
  %c2 = icmp sgt %abs, -1
  %minus2 = sub 0, %abs
  %abs2 = select i1 %c2, %abs, %minus2

=>
  %c = icmp sgt %A, 0
  %minus = sub 0, %A
  %abs = select i1 %c, %A, %minus
  %c2 = icmp sgt %abs, -1
  %minus2 = sub 0, %abs
  %abs2 = select i1 %c, %A, %minus

-/
theorem alive_A : forall (w : Nat) (A : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (0)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp sgt  w %v3;
  %v5 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:sub 1 %v6;
  %v8 := triple:%v4 %v1 %v7;
  %v9 := op:select w %v8;
  %v10 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v11 := pair:%v9 %v10;
  %v12 := op:icmp sgt  w %v11;
  %v13 := op:const (Bitvec.ofInt w (0)) %v0;
  %v14 := pair:%v13 %v9;
  %v15 := op:sub w %v14;
  %v16 := triple:%v12 %v9 %v15;
  %v17 := op:select w %v16
  dsl_ret %v17
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp sgt  1 %v3;
  %v5 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:sub 1 %v6;
  %v8 := triple:%v4 %v1 %v7;
  %v9 := op:select 1 %v8;
  %v10 := op:const (Bitvec.ofInt 1 (-1)) %v0;
  %v11 := pair:%v9 %v10;
  %v12 := op:icmp sgt  1 %v11;
  %v13 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v14 := pair:%v13 %v9;
  %v15 := op:sub 1 %v14;
  %v16 := triple:%v4 %v1 %v7;
  %v17 := op:select 1 %v16
  dsl_ret %v17
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:A
-- precondition: true
/-
  %c = icmp sgt %A, 0
  %minus = sub 0, %A
  %abs = select i1 %c, %minus, %A
  %c2 = icmp sgt %abs, -1
  %minus2 = sub 0, %abs
  %abs2 = select i1 %c2, %minus2, %abs

=>
  %c = icmp sgt %A, 0
  %minus = sub 0, %A
  %abs = select i1 %c, %minus, %A
  %c2 = icmp sgt %abs, -1
  %minus2 = sub 0, %abs
  %abs2 = select i1 %c, %minus, %A

-/
theorem alive_A : forall (w : Nat) (A : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (0)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp sgt  w %v3;
  %v5 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:sub 1 %v6;
  %v8 := triple:%v4 %v7 %v1;
  %v9 := op:select w %v8;
  %v10 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v11 := pair:%v9 %v10;
  %v12 := op:icmp sgt  w %v11;
  %v13 := op:const (Bitvec.ofInt w (0)) %v0;
  %v14 := pair:%v13 %v9;
  %v15 := op:sub w %v14;
  %v16 := triple:%v12 %v15 %v9;
  %v17 := op:select w %v16
  dsl_ret %v17
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp sgt  1 %v3;
  %v5 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:sub 1 %v6;
  %v8 := triple:%v4 %v7 %v1;
  %v9 := op:select 1 %v8;
  %v10 := op:const (Bitvec.ofInt 1 (-1)) %v0;
  %v11 := pair:%v9 %v10;
  %v12 := op:icmp sgt  1 %v11;
  %v13 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v14 := pair:%v13 %v9;
  %v15 := op:sub 1 %v14;
  %v16 := triple:%v4 %v7 %v1;
  %v17 := op:select 1 %v16
  dsl_ret %v17
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:A
-- precondition: true
/-
  %c = icmp slt %A, 0
  %minus = sub 0, %A
  %abs = select i1 %c, %A, %minus
  %c2 = icmp sgt %abs, 0
  %minus2 = sub 0, %abs
  %abs2 = select i1 %c2, %abs, %minus2

=>
  %minus = sub 0, %A
  %c3 = icmp sgt %A, 0
  %c = icmp slt %A, 0
  %abs = select i1 %c, %A, %minus
  %c2 = icmp sgt %abs, 0
  %minus2 = sub 0, %abs
  %abs2 = select i1 %c3, %A, %minus

-/
theorem alive_A : forall (w : Nat) (A : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (0)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp slt  w %v3;
  %v5 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:sub 1 %v6;
  %v8 := triple:%v4 %v1 %v7;
  %v9 := op:select w %v8;
  %v10 := op:const (Bitvec.ofInt w (0)) %v0;
  %v11 := pair:%v9 %v10;
  %v12 := op:icmp sgt  w %v11;
  %v13 := op:const (Bitvec.ofInt w (0)) %v0;
  %v14 := pair:%v13 %v9;
  %v15 := op:sub w %v14;
  %v16 := triple:%v12 %v9 %v15;
  %v17 := op:select w %v16
  dsl_ret %v17
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v2 := op:const (A) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub 1 %v3;
  %v5 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v6 := pair:%v2 %v5;
  %v7 := op:icmp sgt  1 %v6;
  %v8 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v9 := pair:%v2 %v8;
  %v10 := op:icmp slt  1 %v9;
  %v11 := triple:%v10 %v2 %v4;
  %v12 := op:select 1 %v11;
  %v13 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v14 := pair:%v12 %v13;
  %v15 := op:icmp sgt  1 %v14;
  %v16 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v17 := pair:%v16 %v12;
  %v18 := op:sub 1 %v17;
  %v19 := triple:%v7 %v2 %v4;
  %v20 := op:select 1 %v19
  dsl_ret %v20
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:A
-- precondition: true
/-
  %c = icmp sgt %A, 0
  %minus = sub 0, %A
  %abs = select i1 %c, %A, %minus
  %c2 = icmp slt %abs, 0
  %minus2 = sub 0, %abs
  %abs2 = select i1 %c2, %abs, %minus2

=>
  %minus = sub 0, %A
  %c3 = icmp slt %A, 0
  %c = icmp sgt %A, 0
  %abs = select i1 %c, %A, %minus
  %c2 = icmp slt %abs, 0
  %minus2 = sub 0, %abs
  %abs2 = select i1 %c3, %A, %minus

-/
theorem alive_A : forall (w : Nat) (A : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (A) %v0;
  %v2 := op:const (Bitvec.ofInt w (0)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:icmp sgt  w %v3;
  %v5 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v6 := pair:%v5 %v1;
  %v7 := op:sub 1 %v6;
  %v8 := triple:%v4 %v1 %v7;
  %v9 := op:select w %v8;
  %v10 := op:const (Bitvec.ofInt w (0)) %v0;
  %v11 := pair:%v9 %v10;
  %v12 := op:icmp slt  w %v11;
  %v13 := op:const (Bitvec.ofInt w (0)) %v0;
  %v14 := pair:%v13 %v9;
  %v15 := op:sub w %v14;
  %v16 := triple:%v12 %v9 %v15;
  %v17 := op:select w %v16
  dsl_ret %v17
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v2 := op:const (A) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:sub 1 %v3;
  %v5 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v6 := pair:%v2 %v5;
  %v7 := op:icmp slt  1 %v6;
  %v8 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v9 := pair:%v2 %v8;
  %v10 := op:icmp sgt  1 %v9;
  %v11 := triple:%v10 %v2 %v4;
  %v12 := op:select 1 %v11;
  %v13 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v14 := pair:%v12 %v13;
  %v15 := op:icmp slt  1 %v14;
  %v16 := op:const (Bitvec.ofInt 1 (0)) %v0;
  %v17 := pair:%v16 %v12;
  %v18 := op:sub 1 %v17;
  %v19 := triple:%v7 %v2 %v4;
  %v20 := op:select 1 %v19
  dsl_ret %v20
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %A = select i1 %B, true, %C

=>
  %A = or %B, %C

-/
theorem alive_B: forall (C B : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofBool true) %v0;
  %v3 := op:const (C) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select 1 %v4
  dsl_ret %v5
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or 1 %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %A = select i1 %B, false, %C

=>
  %notb = xor i1 %B, true
  %A = and %notb, %C

-/
theorem alive_B: forall (C B : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofBool false) %v0;
  %v3 := op:const (C) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select 1 %v4
  dsl_ret %v5
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofBool true) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor 1 %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and 1 %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %A = select i1 %B, %C, false

=>
  %A = and %B, %C

-/
theorem alive_B: forall (C B : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (C) %v0;
  %v3 := op:const (Bitvec.ofBool false) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select 1 %v4
  dsl_ret %v5
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and 1 %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:B
-- precondition: true
/-
  %A = select i1 %B, %C, true

=>
  %notb = xor i1 %B, true
  %A = or %notb, %C

-/
theorem alive_B: forall (C B : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (C) %v0;
  %v3 := op:const (Bitvec.ofBool true) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select 1 %v4
  dsl_ret %v5
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (B) %v0;
  %v2 := op:const (Bitvec.ofBool true) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor 1 %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:or 1 %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %r = select i1 %a, %b, %a

=>
  %r = and %a, %b

-/
theorem alive_b: forall (a b : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := triple:%v1 %v2 %v1;
  %v4 := op:select 1 %v3
  dsl_ret %v4
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:and 1 %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %r = select i1 %a, %a, %b

=>
  %r = or %a, %b

-/
theorem alive_b: forall (a b : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := triple:%v1 %v1 %v2;
  %v4 := op:select 1 %v3
  dsl_ret %v4
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (b) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:or 1 %v3
  dsl_ret %v4
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %nota = xor %a, -1
  %r = select i1 %a, %nota, %b

=>
  %nota = xor %a, -1
  %r = and %nota, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (b) %v0;
  %v6 := triple:%v1 %v4 %v5;
  %v7 := op:select w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt 1 (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor 1 %v3;
  %v5 := op:const (b) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and 1 %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:b
-- precondition: true
/-
  %nota = xor %a, -1
  %r = select i1 %a, %b, %nota

=>
  %nota = xor %a, -1
  %r = or %nota, %b

-/
theorem alive_b : forall (w : Nat) (a b : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (b) %v0;
  %v6 := triple:%v1 %v5 %v4;
  %v7 := op:select w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (a) %v0;
  %v2 := op:const (Bitvec.ofInt 1 (-1)) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor 1 %v3;
  %v5 := op:const (b) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:or 1 %v6
  dsl_ret %v7
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:x
-- precondition: true
/-
  %s1 = add %x, %y
  %s2 = add %x, %z
  %r = select i1 %c, %s1, %s2

=>
  %yz = select i1 %c, %y, %z
  %s1 = add %x, %y
  %s2 = add %x, %z
  %r = add %x, %yz

-/
theorem alive_x : forall (w : Nat) (y c z : Bitvec 1)
(x : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (x) %v0;
  %v2 := op:const (y) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (z) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:add w %v6;
  %v8 := op:const (c) %v0;
  %v9 := triple:%v8 %v4 %v7;
  %v10 := op:select w %v9
  dsl_ret %v10
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (c) %v0;
  %v2 := op:const (y) %v0;
  %v3 := op:const (z) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select w %v4;
  %v6 := op:const (x) %v0;
  %v7 := pair:%v6 %v2;
  %v8 := op:add w %v7;
  %v9 := pair:%v6 %v3;
  %v10 := op:add w %v9;
  %v11 := pair:%v6 %v5;
  %v12 := op:add w %v11
  dsl_ret %v12
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:W
-- precondition: true
/-
  %X = select i1 %c, %W, %Z
  %r = select i1 %c, %X, %Y

=>
  %X = select i1 %c, %W, %Z
  %r = select i1 %c, %W, %Y

-/
theorem alive_W : forall (w : Nat) (Y c Z W : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (c) %v0;
  %v2 := op:const (W) %v0;
  %v3 := op:const (Z) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select w %v4;
  %v6 := op:const (Y) %v0;
  %v7 := triple:%v1 %v5 %v6;
  %v8 := op:select w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (c) %v0;
  %v2 := op:const (W) %v0;
  %v3 := op:const (Z) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select 1 %v4;
  %v6 := op:const (Y) %v0;
  %v7 := triple:%v1 %v2 %v6;
  %v8 := op:select 1 %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:W
-- precondition: true
/-
  %Y = select i1 %c, %W, %Z
  %r = select i1 %c, %X, %Y

=>
  %Y = select i1 %c, %W, %Z
  %r = select i1 %c, %X, %Z

-/
theorem alive_W : forall (w : Nat) (X c Z W : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (c) %v0;
  %v2 := op:const (W) %v0;
  %v3 := op:const (Z) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select w %v4;
  %v6 := op:const (X) %v0;
  %v7 := triple:%v1 %v6 %v5;
  %v8 := op:select w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 1)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (c) %v0;
  %v2 := op:const (W) %v0;
  %v3 := op:const (Z) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select 1 %v4;
  %v6 := op:const (X) %v0;
  %v7 := triple:%v1 %v6 %v3;
  %v8 := op:select 1 %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:val
-- precondition: true
/-
  %c = xor i1 %val, true
  %r = select i1 %c, %X, %Y

=>
  %c = xor i1 %val, true
  %r = select i1 %val, %Y, %X

-/
theorem alive_val : forall (w : Nat) (Y X val : Bitvec 1)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (val) %v0;
  %v2 := op:const (Bitvec.ofBool true) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor 1 %v3;
  %v5 := op:const (X) %v0;
  %v6 := op:const (Y) %v0;
  %v7 := triple:%v4 %v5 %v6;
  %v8 := op:select w %v7
  dsl_ret %v8
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (val) %v0;
  %v2 := op:const (Bitvec.ofBool true) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor 1 %v3;
  %v5 := op:const (Y) %v0;
  %v6 := op:const (X) %v0;
  %v7 := triple:%v1 %v5 %v6;
  %v8 := op:select w %v7
  dsl_ret %v8
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %r = select i1 true, %X, %Y

=>
  %r = %X

-/
theorem alive_X : forall (w : Nat) (Y X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofBool true) %v0;
  %v2 := op:const (X) %v0;
  %v3 := op:const (Y) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select w %v4
  dsl_ret %v5
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:copy w %v1
  dsl_ret %v2
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:X
-- precondition: true
/-
  %r = select i1 false, %X, %Y

=>
  %r = %Y

-/
theorem alive_X : forall (w : Nat) (Y X : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Bitvec.ofBool false) %v0;
  %v2 := op:const (X) %v0;
  %v3 := op:const (Y) %v0;
  %v4 := triple:%v1 %v2 %v3;
  %v5 := op:select w %v4
  dsl_ret %v5
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Y) %v0;
  %v2 := op:copy w %v1
  dsl_ret %v2
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %Op0 = shl %X, C
  %r = lshr %Op0, C

=>
  %Op0 = shl %X, C
  %r = and %X, (-1 u>> C)

-/
theorem alive_C : forall (w : Nat) (X C : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:lshr w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:lshr w %v6;
  %v8 := pair:%v1 %v7;
  %v9 := op:and w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %Op0 = lshr %X, C
  %r = shl %Op0, C

=>
  %Op0 = lshr %X, C
  %r = and %X, (-1 << C)

-/
theorem alive_C : forall (w : Nat) (X C : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:lshr w %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:shl w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:lshr w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:shl w %v6;
  %v8 := pair:%v1 %v7;
  %v9 := op:and w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C2
-- precondition: true
/-
  %Op0 = mul i7 %X, C1
  %r = shl %Op0, C2

=>
  %Op0 = mul i7 %X, C1
  %r = mul %X, (C1 << C2)

-/
theorem alive_C2: forall (X C1 C2 : Bitvec 7)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 7)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:mul 7 %v3;
  %v5 := op:const (C2) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:shl 7 %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 7)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C1) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:mul 7 %v3;
  %v5 := op:const (C2) %v0;
  %v6 := pair:%v2 %v5;
  %v7 := op:shl 7 %v6;
  %v8 := pair:%v1 %v7;
  %v9 := op:mul 7 %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %Op1 = lshr i31 %X, C
  %Op0 = add %Y, %Op1
  %r = shl %Op0, C

=>
  %s = shl %Y, C
  %a = add %s, %X
  %Op1 = lshr i31 %X, C
  %Op0 = add %Y, %Op1
  %r = and %a, (-1 << C)

-/
theorem alive_C: forall (Y X C : Bitvec 31)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 31)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:lshr 31 %v3;
  %v5 := op:const (Y) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:add 31 %v6;
  %v8 := pair:%v7 %v2;
  %v9 := op:shl 31 %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 31)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Y) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 31 %v3;
  %v5 := op:const (X) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:add 31 %v6;
  %v8 := pair:%v5 %v2;
  %v9 := op:lshr 31 %v8;
  %v10 := pair:%v1 %v9;
  %v11 := op:add 31 %v10;
  %v12 := op:const (Bitvec.ofInt 31 (-1)) %v0;
  %v13 := pair:%v12 %v2;
  %v14 := op:shl 31 %v13;
  %v15 := pair:%v7 %v14;
  %v16 := op:and 31 %v15
  dsl_ret %v16
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %Op1 = ashr i31 %X, C
  %Op0 = add %Y, %Op1
  %r = shl %Op0, C

=>
  %s = shl %Y, C
  %a = add %s, %X
  %Op1 = ashr i31 %X, C
  %Op0 = add %Y, %Op1
  %r = and %a, (-1 << C)

-/
theorem alive_C: forall (Y X C : Bitvec 31)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 31)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:ashr 31 %v3;
  %v5 := op:const (Y) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:add 31 %v6;
  %v8 := pair:%v7 %v2;
  %v9 := op:shl 31 %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 31)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Y) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 31 %v3;
  %v5 := op:const (X) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:add 31 %v6;
  %v8 := pair:%v5 %v2;
  %v9 := op:ashr 31 %v8;
  %v10 := pair:%v1 %v9;
  %v11 := op:add 31 %v10;
  %v12 := op:const (Bitvec.ofInt 31 (-1)) %v0;
  %v13 := pair:%v12 %v2;
  %v14 := op:shl 31 %v13;
  %v15 := pair:%v7 %v14;
  %v16 := op:and 31 %v15
  dsl_ret %v16
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C2
-- precondition: true
/-
  %s = lshr %X, C
  %Op1 = and %s, C2
  %Op0 = xor %Y, %Op1
  %r = shl %Op0, C

=>
  %a = and %X, (C2 << C)
  %y2 = shl %Y, C
  %s = lshr %X, C
  %Op1 = and %s, C2
  %Op0 = xor %Y, %Op1
  %r = xor %a, %y2

-/
theorem alive_C2 : forall (w : Nat) (Y X C C2 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:lshr w %v3;
  %v5 := op:const (C2) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and w %v6;
  %v8 := op:const (Y) %v0;
  %v9 := pair:%v8 %v7;
  %v10 := op:xor w %v9;
  %v11 := pair:%v10 %v2;
  %v12 := op:shl w %v11
  dsl_ret %v12
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C2) %v0;
  %v3 := op:const (C) %v0;
  %v4 := pair:%v2 %v3;
  %v5 := op:shl w %v4;
  %v6 := pair:%v1 %v5;
  %v7 := op:and w %v6;
  %v8 := op:const (Y) %v0;
  %v9 := pair:%v8 %v3;
  %v10 := op:shl w %v9;
  %v11 := pair:%v1 %v3;
  %v12 := op:lshr w %v11;
  %v13 := pair:%v12 %v2;
  %v14 := op:and w %v13;
  %v15 := pair:%v8 %v14;
  %v16 := op:xor w %v15;
  %v17 := pair:%v7 %v10;
  %v18 := op:xor w %v17
  dsl_ret %v18
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %s = ashr i31 %X, C
  %Op0 = sub %s, %Y
  %r = shl %Op0, C

=>
  %s2 = shl %Y, C
  %a = sub %X, %s2
  %s = ashr i31 %X, C
  %Op0 = sub %s, %Y
  %r = and %a, (-1 << C)

-/
theorem alive_C: forall (Y X C : Bitvec 31)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 31)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:ashr 31 %v3;
  %v5 := op:const (Y) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:sub 31 %v6;
  %v8 := pair:%v7 %v2;
  %v9 := op:shl 31 %v8
  dsl_ret %v9
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 31)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Y) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 31 %v3;
  %v5 := op:const (X) %v0;
  %v6 := pair:%v5 %v4;
  %v7 := op:sub 31 %v6;
  %v8 := pair:%v5 %v2;
  %v9 := op:ashr 31 %v8;
  %v10 := pair:%v9 %v1;
  %v11 := op:sub 31 %v10;
  %v12 := op:const (Bitvec.ofInt 31 (-1)) %v0;
  %v13 := pair:%v12 %v2;
  %v14 := op:shl 31 %v13;
  %v15 := pair:%v7 %v14;
  %v16 := op:and 31 %v15
  dsl_ret %v16
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C2
-- precondition: true
/-
  %shr = lshr %X, C
  %s = and %shr, C2
  %Op0 = or %s, %Y
  %r = shl %Op0, C

=>
  %s2 = shl %Y, C
  %a = and %X, (C2 << C)
  %shr = lshr %X, C
  %s = and %shr, C2
  %Op0 = or %s, %Y
  %r = or %a, %s2

-/
theorem alive_C2 : forall (w : Nat) (Y X C C2 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:lshr w %v3;
  %v5 := op:const (C2) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:and w %v6;
  %v8 := op:const (Y) %v0;
  %v9 := pair:%v7 %v8;
  %v10 := op:or w %v9;
  %v11 := pair:%v10 %v2;
  %v12 := op:shl w %v11
  dsl_ret %v12
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (Y) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3;
  %v5 := op:const (X) %v0;
  %v6 := op:const (C2) %v0;
  %v7 := pair:%v6 %v2;
  %v8 := op:shl w %v7;
  %v9 := pair:%v5 %v8;
  %v10 := op:and w %v9;
  %v11 := pair:%v5 %v2;
  %v12 := op:lshr w %v11;
  %v13 := pair:%v12 %v6;
  %v14 := op:and w %v13;
  %v15 := pair:%v14 %v1;
  %v16 := op:or w %v15;
  %v17 := pair:%v10 %v4;
  %v18 := op:or w %v17
  dsl_ret %v18
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C2
-- precondition: true
/-
  %Op0 = xor %X, C2
  %r = lshr %Op0, C

=>
  %s2 = lshr %X, C
  %Op0 = xor %X, C2
  %r = xor %s2, (C2 u>> C)

-/
theorem alive_C2 : forall (w : Nat) (X C C2 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C2) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:xor w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:lshr w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:lshr w %v3;
  %v5 := op:const (C2) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:xor w %v6;
  %v8 := pair:%v5 %v2;
  %v9 := op:lshr w %v8;
  %v10 := pair:%v4 %v9;
  %v11 := op:xor w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C2
-- precondition: true
/-
  %Op0 = add %X, C2
  %r = shl %Op0, C

=>
  %s2 = shl %X, C
  %Op0 = add %X, C2
  %r = add %s2, (C2 << C)

-/
theorem alive_C2 : forall (w : Nat) (X C C2 : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C2) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:add w %v3;
  %v5 := op:const (C) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:shl w %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3;
  %v5 := op:const (C2) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:add w %v6;
  %v8 := pair:%v5 %v2;
  %v9 := op:shl w %v8;
  %v10 := pair:%v4 %v9;
  %v11 := op:add w %v10
  dsl_ret %v11
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C
-- precondition: true
/-
  %Op0 = shl %X, C
  %r = lshr %Op0, C

=>
  %Op0 = shl %X, C
  %r = and %X, (-1 u>> C)

-/
theorem alive_C : forall (w : Nat) (X C : Bitvec w)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3;
  %v5 := pair:%v4 %v2;
  %v6 := op:lshr w %v5
  dsl_ret %v6
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec w)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (X) %v0;
  %v2 := op:const (C) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl w %v3;
  %v5 := op:const (Bitvec.ofInt w (-1)) %v0;
  %v6 := pair:%v5 %v2;
  %v7 := op:lshr w %v6;
  %v8 := pair:%v1 %v7;
  %v9 := op:and w %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error

-- Name:C1
-- precondition: true
/-
  %Op0 = shl i31 C1, %A
  %r = shl %Op0, C2

=>
  %Op0 = shl i31 C1, %A
  %r = shl (C1 << C2), %A

-/
theorem alive_C1: forall (A C2 C1 : Bitvec 31)
, TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 31)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (C1) %v0;
  %v2 := op:const (A) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 31 %v3;
  %v5 := op:const (C2) %v0;
  %v6 := pair:%v4 %v5;
  %v7 := op:shl 31 %v6
  dsl_ret %v7
  ]  ⊑
  TSSA.eval
  (Op := Op) (e := e)
  (i := TSSAIndex.STMT (UserType.base (BaseType.bitvec 31)))
  [dsl_bb|
  ^bb
  %v0 := unit: ;
  %v1 := op:const (C1) %v0;
  %v2 := op:const (A) %v0;
  %v3 := pair:%v1 %v2;
  %v4 := op:shl 31 %v3;
  %v5 := op:const (C2) %v0;
  %v6 := pair:%v1 %v5;
  %v7 := op:shl 31 %v6;
  %v8 := pair:%v7 %v2;
  %v9 := op:shl 31 %v8
  dsl_ret %v9
  ]
  := by
     simp_mlir
     simp_alive
     print_goal_as_error