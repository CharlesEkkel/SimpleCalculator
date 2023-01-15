module Utils.Maths where

import Prelude

import Data.Array (foldl, (..))
import Data.Int (floor, toNumber)
import Data.Number as N

log :: Number -> Number -> Number
log base value = (N.log value) / (N.log base)

-- Number is required...
factorial :: Number -> Number
factorial n =
  if N.floor n == n then toNumber $ foldl (*) 1 (2 .. (floor n))
  else 0.0

degToRad :: Number -> Number
degToRad deg = deg * N.pi / 180.0
