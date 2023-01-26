module Logic.Digits where

import Prelude

import Data.String.Utils (toCharArray)
import Data.Array as Array
import Data.Decimal (Decimal)
import Data.Decimal as Decimal
import Data.Enum (class Enum)
import Data.Enum.Generic (genericPred, genericSucc)
import Data.Foldable (foldMap)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String as String
import Data.String.CodeUnits (charAt)
import Data.Traversable (traverse)
import Data.Tuple (Tuple(..))
import Data.Unfoldable (class Unfoldable, unfoldr)

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

newtype Digits = Digits (Array DigitValue)

derive newtype instance Eq Digits
derive newtype instance Semigroup Digits
derive newtype instance Monoid Digits

instance Show Digits where
  show = (<>) "Digits " <<< digitsToString

addToDigits :: DigitValue -> Digits -> Digits
addToDigits d (Digits digits) = Digits $ digits `Array.snoc` d

removeLastDigit :: Digits -> Digits
removeLastDigit (Digits digits) = Digits $ fromMaybe [] $ map (_.init) $ Array.unsnoc digits

toDecimal :: Digits -> Maybe Decimal
toDecimal = Decimal.fromString <<< digitsToString

type Precision = Int

-- | Precision is the number of significant figures to round to.
fromDecimal :: Precision -> Decimal -> Maybe Digits
fromDecimal p dec = stringToDigits $ Decimal.toPrecision p dec

-- | A Just return value requires that the string only contain valid digits (including a decimal point).
stringToDigits :: String -> Maybe Digits
stringToDigits = map Digits <<< traverse stringToDigit <<< toCharArray

digitsToString :: Digits -> String
digitsToString (Digits digits) = foldMap digitToString digits

appendDigit :: DigitValue -> Digits -> Digits
appendDigit newDigit (Digits digits) = Digits $ Array.snoc digits newDigit

-- | A Nothing return value means that there was nothing to remove.
removeDigit :: Digits -> Maybe Digits
removeDigit (Digits digits) = Digits <$> map (_.init) (Array.unsnoc digits)

singleton :: DigitValue -> Digits
singleton = Digits <<< Array.singleton
