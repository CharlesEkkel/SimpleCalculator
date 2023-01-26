module Logic.Digits where

import Prelude

import Data.Array as Array
import Data.Decimal (Decimal, toFixed, toString)
import Data.Decimal as Decimal
import Data.Either (Either(..))
import Data.Enum (class Enum)
import Data.Enum.Generic (genericPred, genericSucc)
import Data.Foldable (fold, foldMap)
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
import Data.String.CodeUnits (charAt, toChar, toCharArray)
import Data.String.Regex as Regex
import Data.String.Regex as Regex
import Data.String.Regex.Flags (noFlags)
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.Traversable (traverse)
import Data.Tuple (Tuple(..))
import Data.Unfoldable (class Unfoldable, unfoldr)
import Partial.Unsafe (unsafePartial)
import Utils.Maths (intLen)

-- | Explicit digits
data Digit = Zero | One | Two | Three | Four | Five | Six | Seven | Eight | Nine | Decimal

derive instance Eq Digit
derive instance Ord Digit
derive instance Generic Digit _

instance Show Digit where
  show = (<>) "Digit " <<< digitToString

instance Enum Digit where
  pred = genericPred
  succ = genericSucc

digitToString :: Digit -> String
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

charToDigit :: Char -> Maybe Digit
charToDigit = case _ of
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
  '.' -> Just Decimal
  _ -> Nothing

intToDigit :: Int -> Maybe Digit
intToDigit = charToDigit <=< toChar <<< show

newtype Digits = Digits (List Digit)

derive newtype instance Eq Digits
derive newtype instance Semigroup Digits
derive newtype instance Monoid Digits

instance Show Digits where
  show = (<>) "Digits " <<< digitsToString

digitsToString :: Digits -> String
digitsToString (Digits digits) = foldMap digitToString digits

digitsCount :: Digits -> Int
digitsCount (Digits digits) = length digits

toDecimal :: Digits -> Maybe Decimal
toDecimal = Decimal.fromString <<< digitsToString

toChars :: forall m. Unfoldable m => String -> m Char
toChars = unfoldr nextChar
  where
  nextChar str = Tuple <$> charAt 0 str <*> Just (String.drop 1 str)

type Precision = Int

fromDecimal :: Precision -> Decimal -> Maybe Digits
fromDecimal p dec =
  if String.contains (Pattern "\\.") numStr then stringToDigits numStr
  else case String.split (Pattern "e") numStr of
    [ digits ] -> stringToDigits digits
    [ digits, sigFigs ] -> stringToDigits digits
    _ -> Nothing

  where
  numStr = Decimal.toPrecision p dec

-- | A Just return value requires that the string only contain valid digits (including a decimal point).
stringToDigits :: String -> Maybe Digits
stringToDigits = map Digits <<< traverse charToDigit <<< toChars

appendDigit :: Digit -> Digits -> Digits
appendDigit newDigit (Digits digits) = Digits $ newDigit : digits

-- | A Nothing return value means that there was nothing to remove.
removeDigit :: Digits -> Maybe Digits
removeDigit (Digits digits) = Digits <$> map (_.tail) (List.uncons digits)

singleton :: Digit -> Digits
singleton = Digits <<< List.singleton
