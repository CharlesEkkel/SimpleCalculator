module DigitTest where

import Prelude

import Data.Decimal (fromInt, fromNumber)
import Data.Decimal as Decimal
import Data.Maybe (Maybe(..))
import Data.Unfoldable (replicate)
import Logic.Digits (DigitValue(..), Digits(..))
import Logic.Digits as Digits
import Test.QuickCheck (Result, (===))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.QuickCheck (quickCheck)

digitTests :: Spec Unit
digitTests = do
  describe "Converting an int to digits" do
    it "converts an int to digits and back just fine" do
      quickCheck func

    it "converts a number to digits and back just fine" do
      quickCheck func2
  -- it "can deal with 10 ^ 20" do
  --   stringToDigits (show $ 10 `Int.pow` 20) `shouldEqual` Just (intToDigits (10 `Int.pow` 7))

  -- describe "Converting a number to a preciseNum" do
  --   it "converts 0.51 properly" do
  --     Digits.fromDecimal 20 (fromNumber 0.51) `shouldEqual` Just (Digits [ Zero, Decimal, Five, One ])
  --   it "can deal with long whole numbers" do
  --      let dec = (fromInt 1 * (fromInt 10 `Decimal.pow` fromInt 15))
  --      Digits.fromDecimal 20 dec `shouldEqual` Digits (
  --   it "can deal with long decimals" do
  --     -- (fromInt 1 / (fromInt 10 `Decimal.pow` fromInt 15)) `shouldEqual` fromInt 5
  --     Digits.fromDecimal 20 (fromInt 1 / (fromInt 10 `Decimal.pow` fromInt 15)) `shouldEqual` Just (Digits ([ Zero, Decimal ] <> replicate 14 Zero <> [ One ]))
  -- it "converts back and forth" do
  --   quickCheck \num -> preciseToNumber <$> numToPrecise num === Just num
  where
  func :: Int -> Result
  func int = Digits.digitsToString <$> Digits.stringToDigits (show int) === Just (show int)

  func2 :: Number -> Result
  func2 num = Digits.digitsToString <$> Digits.stringToDigits (show num) === Just (show num)
