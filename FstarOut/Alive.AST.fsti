module Alive.AST
let const (n : nat) (x : int) : option int = Some x
let add (n : nat) (x : int) (y : int) : option int = Some y
let sub (n : nat) (x : int) (y : int) : option int = Some x


let lhs1 (a : nat) : option int  = const 32 10
let lhs2 (a : nat) : option int = None

(* what the actual hell is going on? why is this accepted? *)
let proof1 () : Lemma (10 == 20) = ()
