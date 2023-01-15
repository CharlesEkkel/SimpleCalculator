module Utils.Maths where

import Prelude

import Data.Number as N

log :: Number -> Number -> Number
log base value = (N.log value) / (N.log base)
