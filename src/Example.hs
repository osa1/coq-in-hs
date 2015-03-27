{-# LANGUAGE QuasiQuotes #-}

module Example where

import Coq
import CoqLibs

[coq|
Function my_add (x : nat) (y : nat) : nat :=
  match x with
  | 0    => y
  | S x' => S (my_add x' y)
  end.

Theorem my_add_assoc : forall x y z, my_add (my_add x y) z = my_add x (my_add y z).
Proof.
  induction x.
  + intros. reflexivity.
  + intros. simpl. f_equal. apply IHx.
Qed.

Theorem my_add_0_l : forall x, my_add x 0 = x.
Proof.
  induction x. reflexivity. simpl. f_equal. apply IHx.
Qed.

Theorem my_add_comm : forall x y, my_add x y = my_add y x.
Proof.
  induction x.
  + intro. rewrite my_add_0_l. reflexivity.
  + intro. simpl. rewrite IHx; clear IHx. induction y; auto.
Qed.

Extraction my_add.
|]
