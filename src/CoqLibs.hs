{-# LANGUAGE QuasiQuotes, StandaloneDeriving #-}

module CoqLibs where

import Coq

[coq|
Extraction nat.
|]

deriving instance Show Nat
deriving instance Eq Nat
