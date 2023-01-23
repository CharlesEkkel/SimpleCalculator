module Logic.Digits where

import Prelude

import Data.Decimal (Decimal)
import Data.Decimal as Decimal
import Data.Either (Either(..))
import Data.Enum (class Enum)
import Data.Enum.Generic (genericPred, genericSucc)
import Data.Foldable (fold)
import Data.FoldableWithIndex (foldlWithIndex)
import Data.Generic.Rep (class Generic)
import Data.Int (pow, toNumber)
import Data.Int as Int
import Data.List (List(..), insertAt, length, reverse, (:))
import Data.List as List
import Data.Maybe (Maybe(..), fromJust, fromMaybe, isNothing, maybe')
import Data.Ord (abs)
import Data.String (Pattern(..), split)
import Data.String as String
import Data.String.CodeUnits (toCharArray, toChar)
import Data.Traversable (traverse)
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

intCharToDigit :: Char -> Maybe Digit
intCharToDigit = case _ of
  '0' -> Just Zero
  '1' -> Just One
  '2' -> Just Two
  '3' -> Just Three
  '4' -> Just Four
  '5' -> Just Five
  '6' -> Just Six
  '7' -> Just Seven
  '8' -> Just Eight
  '9' -> Just Nine
  _ -> Nothing

intToDigit :: Int -> Maybe Digit
intToDigit = intCharToDigit <=< toChar <<< show

digitToNumber :: Digit -> Number
digitToNumber = toNumber <<< digitToInt

type DecimalPosition = Maybe Int

noDecimal :: DecimalPosition
noDecimal = Nothing

incrementDecimalPosition :: DecimalPosition -> DecimalPosition
incrementDecimalPosition pos = (+) 1 <$> pos

decrementDecimalPosition :: DecimalPosition -> DecimalPosition
decrementDecimalPosition pos = flip (-) 1 <$> pos

data Digits = Digits DecimalPosition (List Digit)

derive instance Eq Digits
-- derive newtype instance Semigroup Digits
-- derive newtype instance Monoid Digits

instance Show Digits where
  show (Digits decPos digits) =
    maybe'
      (\_ -> fold $ reverse $ map show $ digits)
      (\digitsWithDec -> fold $ reverse $ map show $ digitsWithDec)
      do
        pos <- decPos
        insertAt pos "." (map show digits)

mkDigitsInt :: List Digit -> Digits
mkDigitsInt = Digits noDecimal

digitsCount :: Digits -> Int
digitsCount (Digits _ digits) = length digits

isInt :: Digits -> Boolean
isInt (Digits pos _) = isNothing pos

-- | Convert list of digits to a single integer, starting with the 1's column.
-- | For example: 
-- | >> digitsToInt [Two, Zero, Three] == 203
rawDigitsToInt :: List Digit -> Int
rawDigitsToInt digits = foldlWithIndex (\i num dig -> num + (digitToInt dig) * (10 `pow` i)) 0 digits

digitsToDecimal :: Digits -> Decimal
digitsToDecimal = unsafePartial fromJust <<< Decimal.fromString <<< show

intToDigits :: Int -> Digits
intToDigits x =
  show x
    # toCharArray
    # List.fromFoldable
    # traverse intCharToDigit
    # unsafePartial fromJust
    # mkDigitsInt

decimalToDigits :: Decimal -> Digits
decimalToDigits x = unsafePartial fromJust case split (Pattern ".") (show x) of
  [ whole, dec ] ->
    if dec == "0" then stringToDigits whole
    else withDecimalPosition (Just $ String.length dec) <$> (stringToDigits $ whole <> dec)
  _ -> Nothing -- Should not happen!

  where
  withDecimalPosition :: DecimalPosition -> Digits -> Digits
  withDecimalPosition pos (Digits _ digits) = Digits pos digits

extractDigit :: Int -> Int -> Maybe Digit
extractDigit int column =
  let
    powerOfTen = 10 `pow` abs column
    onlyRightInt = (abs int) `mod` powerOfTen
    onlyDigit = onlyRightInt `div` (powerOfTen / 10)
  in
    if column > intLen int then Nothing
    else intToDigit onlyDigit

stringToDigits :: String -> Maybe Digits
stringToDigits = map intToDigits <<< Int.fromString

appendDigit :: Digit -> Digits -> Digits
appendDigit newDigit (Digits pos digits) = case pos of
  Nothing -> Digits noDecimal $ newDigit : digits
  Just _ -> Digits (incrementDecimalPosition pos) $ newDigit : digits

-- | A Nothing return value means that there was nothing to remove.
removeDigit :: Digits -> Maybe Digits
removeDigit = case _ of
  Digits pos digits -> case digits of
    Nil -> Nothing
    Cons _ rest -> Just $ Digits (decrementDecimalPosition pos) rest

singleton :: Digit -> Digits
singleton = Digits noDecimal <<< List.singleton
