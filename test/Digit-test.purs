module DigitTest where

import Prelude

import Data.Int (rem)
import Data.Maybe (Maybe(..))
import Data.Ord (abs)
import Logic.Digits (digitToInt, digitsCount, extractDigit, intToDigits)
import Test.QuickCheck ((===))
import Test.Spec (Spec, describe, it)
import Test.Spec.QuickCheck (quickCheck)
import Utils.Maths (intLen)

digitTests :: Spec Unit
digitTests = do
  describe "Converting an int to digits" do
    it "extracts the ones column digit" do
      quickCheck \int -> digitToInt <$> extractDigit int 1 === Just (abs int `rem` 10)
    it "should have equivalent length" do
      quickCheck \int -> digitsCount (intToDigits int) === intLen int
