# Coq-in-Haskell

### aka. "I have no idea what I'm doing"

Main problems:

* No way to move declarations from Haskell to Coq.
* Every quotation runs separately, in a fresh Coq environment. No way to use
  previously defined Coq definitions in a different quotation.
* No way to add Haddocks if we do multiple extractions from single quotation.
* Need to be careful to not extract dependencies multiple times.
* May not worth the effort.
