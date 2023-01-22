module Logic.Digits where

import Prelude

import Data.Enum (class Enum)
import Data.Enum.Generic (genericPred, genericSucc)
import Data.Foldable (fold)
import Data.FoldableWithIndex (foldlWithIndex)
import Data.Generic.Rep (class Generic)
import Data.Int (fromString, pow, toNumber)
import Data.Int as Int
import Data.List (List(..), length, reverse, (..), (:))
import Data.List as List
import Data.Maybe (Maybe(..), fromJust)
import Data.Number (floor)
import Data.Ord (abs)
import Data.String (Pattern(..), split)
import Partial.Unsafe (unsafePartial)
import Utils.Maths (intLen)

-- | Explicit digits
data Digit = Zero | One | Two | Three | Four | Five | Six | Seven | Eight | Nine

derive instance Eq Digit
derive instance Ord Digit
derive instance Generic Digit _

instance Show Digit where
  show = show <<< digitToInt

instance Enum Digit where
  pred = genericPred
  succ = genericSucc

digitToInt :: Digit -> Int
digitToInt = case _ of
  Zero -> 0
  One -> 1
  Two -> 2
  Three -> 3
  Four -> 4
  Five -> 5
  Six -> 6
  Seven -> 7
  Eight -> 8
  Nine -> 9

intToDigit :: Int -> Maybe Digit
intToDigit = case _ of
  0 -> Just Zero
  1 -> Just One
  2 -> Just Two
  3 -> Just Three
  4 -> Just Four
  5 -> Just Five
  6 -> Just Six
  7 -> Just Seven
  8 -> Just Eight
  9 -> Just Nine
  _ -> Nothing

digitToNumber :: Digit -> Number
digitToNumber = toNumber <<< digitToInt

-- Yes, array has poor time complexity. But its constant performance is better than
-- most anything else so since the arrays are so small, why not?
newtype Digits = Digits (List Digit)

derive newtype instance Semigroup Digits
derive newtype instance Monoid Digits

instance Show Digits where
  show (Digits digits) = fold $ map show $ digits

digitsCount :: Digits -> Int
digitsCount (Digits digits) = length digits

-- | Convert list of digits to a single number, starting with the 1's column.
-- | For example: 
-- | >> digitsToInt (Digits [Two, Zero, Three]) == 203
digitsToInt :: Digits -> Int
digitsToInt (Digits digits) = foldlWithIndex (\i num dig -> num + (digitToInt dig) * (10 `pow` i)) 0 digits

digitsToNumber :: Digits -> Digits -> Number
digitsToNumber whole decimal =
  let
    left = toNumber $ digitsToInt whole
    right = toNumber $ digitsToInt decimal
  in
    left + (right / toNumber (digitsCount decimal))

intToDigits :: Int -> Digits
intToDigits x =
  1 .. intLen x
    # map (extractDigit x)
    # map (unsafePartial fromJust)
    # Digits

consDigit :: Digit -> Digits -> Digits
consDigit digit (Digits digits) = Digits (digit : digits)

extractDigit :: Int -> Int -> Maybe Digit
extractDigit int column =
  let
    powerOfTen = 10 `pow` (abs column - 1)
    onlyRightInt = (abs int) `mod` powerOfTen
    onlyDigit = onlyRightInt `div` powerOfTen
  in
    if powerOfTen - int > 0 then Nothing
    else intToDigit onlyDigit

stringToDigits :: String -> Maybe Digits
stringToDigits = map intToDigits <<< Int.fromString

data PreciseNum = PreciseInt Digits | PreciseDec Digits Digits

instance Show PreciseNum where
  show = case _ of
    PreciseInt digits -> show digits
    PreciseDec whole dec -> show whole <> "." <> show dec

preciseToNumber :: PreciseNum -> Number
preciseToNumber = case _ of
  PreciseInt digits -> toNumber (digitsToInt digits)
  PreciseDec whole dec ->
    toNumber (digitsToInt whole)
      + (toNumber (digitsToInt dec) / toNumber (digitsCount dec))

numberToPrecise :: Number -> PreciseNum
numberToPrecise x = (unsafePartial fromJust) $ case split (Pattern ".") (show x) of
  [ number ] -> PreciseInt <$> stringToDigits number
  [ whole, dec ] -> PreciseDec <$> stringToDigits whole <*> stringToDigits dec
  _ -> Nothing -- Should be impossible, given the nature of Numbers in purescript.

appendDigit :: Digit -> PreciseNum -> PreciseNum
appendDigit newDigit = case _ of
  PreciseInt digits -> PreciseInt $ newDigit `consDigit` digits
  PreciseDec whole dec -> PreciseDec whole $ newDigit `consDigit` dec

-- | A Nothing return value means that there was nothing to remove.
removeDigit :: PreciseNum -> Maybe PreciseNum
removeDigit = case _ of
  PreciseInt (Digits digits) -> case digits of
    Nil -> Nothing
    Cons _ rest -> Just $ PreciseInt $ Digits rest
  PreciseDec whole (Digits dec) -> case dec of
    Nil -> Just $ PreciseInt whole
    Cons _ rest -> Just $ PreciseDec whole $ Digits rest

digitToPrecNum :: Digit -> PreciseNum
digitToPrecNum = PreciseInt <<< Digits <<< List.singleton
