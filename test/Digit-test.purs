module DigitTest where

import Prelude

import Data.Decimal (fromInt, fromNumber)
import Data.Int (rem)
import Data.Int as Int
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Data.Number (pow)
import Data.Ord (abs)
import Data.Unfoldable (replicate)
import Logic.Digits (Digit(..), Digits(..), decimalToDigits, digitToInt, digitsCount, extractDigit, intToDigits, stringToDigits)
import Test.QuickCheck ((===))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.QuickCheck (quickCheck)
import Utils.Maths (intLen)

digitTests :: Spec Unit
digitTests = do
  describe "Converting an int to digits" do
    it "extracts the ones column digit" do
      quickCheck \int -> digitToInt <$> extractDigit int 1 === Just (abs int `rem` 10)
    it "should have equivalent length" do
      quickCheck \int -> digitsCount (intToDigits int) === intLen int
    it "converts a string to digits just fine" do
      quickCheck \int -> stringToDigits (show int) === Just (intToDigits int)
    it "can deal with 10 ^ 20" do
      stringToDigits (show $ 10 `Int.pow` 20) `shouldEqual` Just (intToDigits (10 `Int.pow` 7))

  describe "Converting a number to a preciseNum" do
    it "converts 0.51 properly" do
      decimalToDigits (fromNumber 0.51) `shouldEqual` Digits (Just 2) (One : Five : Zero : Nil)
    it "can deal with long whole numbers" do
      decimalToDigits (fromInt $ 1 * (1 `Int.pow` 15)) `shouldEqual` Digits Nothing (replicate 15 Zero <> One : Nil)
    it "can deal with long decimals" do
      decimalToDigits (fromNumber $ 1.0 / (10.0 `pow` 15.0)) `shouldEqual` Digits (Just 15) (One : replicate 14 Zero)
-- it "converts back and forth" do
--   quickCheck \num -> preciseToNumber <$> numToPrecise num === Just num
