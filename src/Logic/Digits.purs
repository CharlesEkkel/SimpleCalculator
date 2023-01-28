module Logic.Digits where

import Prelude

import Data.Array as Array
import Data.Decimal (Decimal)
import Data.Decimal as Decimal
import Data.Enum (class Enum)
import Data.Enum.Generic (genericPred, genericSucc)
import Data.Foldable (foldMap)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, modify, unwrap, wrap)
import Data.String as String
import Data.String.Utils (toCharArray)
import Data.Traversable (traverse)
import Data.Tuple (fst)

-- | Explicit digits for type safety
data DigitValue = Zero | One | Two | Three | Four | Five | Six | Seven | Eight | Nine | Decimal | Exponent | Positive | Negative

derive instance Eq DigitValue
derive instance Ord DigitValue
derive instance Generic DigitValue _

instance Show DigitValue where
  show = digitToString

instance Enum DigitValue where
  pred = genericPred
  succ = genericSucc

digitToString :: DigitValue -> String
digitToString = case _ of
  Zero -> "0"
  One -> "1"
  Two -> "2"
  Three -> "3"
  Four -> "4"
  Five -> "5"
  Six -> "6"
  Seven -> "7"
  Eight -> "8"
  Nine -> "9"
  Decimal -> "."
  Exponent -> "e"
  Positive -> "+"
  Negative -> "-"

stringToDigit :: String -> Maybe DigitValue
stringToDigit = case _ of
  "0" -> Just Zero
  "1" -> Just One
  "2" -> Just Two
  "3" -> Just Three
  "4" -> Just Four
  "5" -> Just Five
  "6" -> Just Six
  "7" -> Just Seven
  "8" -> Just Eight
  "9" -> Just Nine
  "." -> Just Decimal
  "e" -> Just Exponent
  "+" -> Just Positive
  "-" -> Just Negative
  _ -> Nothing

newtype Digits = Digits String

derive newtype instance Eq Digits
derive newtype instance Semigroup Digits
derive newtype instance Monoid Digits
derive instance Newtype Digits _

instance Show Digits where
  show = (<>) "Digits " <<< digitsToString

addDigit :: DigitValue -> Digits -> Digits
addDigit newDigit = modify (digitToString newDigit <> _)

-- | A Nothing return value means that there was nothing to remove.
removeDigit :: Digits -> Maybe Digits
removeDigit = map (wrap <<< _.tail) <<< String.uncons <<< unwrap

toDecimal :: Digits -> Maybe Decimal
toDecimal = Decimal.fromString <<< digitsToString

type Precision = Int

fromDecimal :: Decimal -> Maybe Digits
fromDecimal dec = stringToDigits $ Decimal.toString dec

-- | A Just return value requires that the string only contain valid digits (including a decimal point).
stringToDigits :: String -> Maybe Digits
stringToDigits = map (Digits <<< reverseString <<< foldMap digitToString) <<< traverse stringToDigit <<< toCharArray

digitsToString :: Digits -> String
digitsToString = reverseString <<< unwrap

reverseString :: String -> String
reverseString = String.fromCodePointArray <<< Array.reverse <<< String.toCodePointArray

singleton :: DigitValue -> Digits
singleton = Digits <<< digitToString
