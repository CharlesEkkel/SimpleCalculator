module Utils.Maths where

import Prelude

import Data.Array (foldl, (..))
import Data.Int (floor, fromString, toNumber)
import Data.Maybe (Maybe(..), fromJust)
import Data.Number as N
import Data.String (Pattern(..), split)
import Data.Tuple (Tuple(..))
import Partial.Unsafe (unsafePartial)

log :: Number -> Number -> Number
log base value = (N.log value) / (N.log base)

-- Number is required...
factorial :: Number -> Number
factorial n =
  if isInt n then toNumber $ foldl (*) 1 (2 .. (floor n))
  else 0.0

degToRad :: Number -> Number
degToRad deg = deg * N.pi / 180.0

isInt :: Number -> Boolean
isInt x = N.floor x == x

intLen :: Int -> Int
intLen = (+) 1 <<< floor <<< log 10.0 <<< toNumber

-- | Theoretically this is a total function, given:
-- | >> splitDecimal 1.2 == Tuple 1 2
-- | And as far as I know, numbers cannot be larger than
-- | integers, so that shouldn't cause an issue either.
-- | Hence the 'unsafePartial'.
splitDecimal :: Number -> Tuple Int Int
splitDecimal x =
  unsafePartial $ fromJust $ case (split (Pattern ".") (show x)) of
    [ whole, decimal ] -> Tuple <$> fromString whole <*> fromString decimal
    _ -> Nothing
