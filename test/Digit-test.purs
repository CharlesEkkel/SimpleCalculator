module DigitTest where

import Prelude

import Data.Decimal (Decimal, fromInt, fromNumber)
import Data.Decimal as Decimal
import Data.Int (rem)
import Data.Int as Int
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Data.Number (pow)
import Data.Ord (abs)
import Data.Unfoldable (replicate)
import Logic.Digits (Digit(..), Digits(..), digitsCount, stringToDigits)
import Logic.Digits as Digits
import Test.QuickCheck (Result, (===))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.QuickCheck (quickCheck)
import Utils.Maths (intLen)

digitTests :: Spec Unit
digitTests = do
  describe "Converting an int to digits" do
    it "converts an int to digits and back just fine" do
      quickCheck func
  -- it "can deal with 10 ^ 20" do
  --   stringToDigits (show $ 10 `Int.pow` 20) `shouldEqual` Just (intToDigits (10 `Int.pow` 7))

  describe "Converting a number to a preciseNum" do
    it "converts 0.51 properly" do
      Digits.fromDecimal 20 (fromNumber 0.51) `shouldEqual` Just (Digits (One : Five : Decimal : Zero : Nil))
    it "can deal with long whole numbers" do
      Digits.fromDecimal 20 (fromInt $ 1 * (10 `Int.pow` 15)) `shouldEqual` Just (Digits (replicate 15 Zero <> One : Nil))
    it "can deal with long decimals" do
      Digits.fromDecimal 20 (fromNumber $ 1.0 / (10.0 `pow` 15.0)) `shouldEqual` Just (Digits (One : replicate 14 Zero <> Decimal : Zero : Nil))
  -- it "converts back and forth" do
  --   quickCheck \num -> preciseToNumber <$> numToPrecise num === Just num
  where
  func :: Int -> Result
  func int = Digits.digitsToString <$> Digits.stringToDigits (show int) === Just (show int)
