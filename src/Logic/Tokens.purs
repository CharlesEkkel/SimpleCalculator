module Logic.Tokens where

import Prelude

import Data.Decimal (cos, factorial, fromInt, ln, log10, pow, sin, sqrt, tan)
import Logic.Digits (DigitValue(..))
import Logic.MathTree (BinaryOp(..), Bracket(..), Priority(..), Token(..), UnaryOp(..))

zero :: Token
zero = DigitToken Zero

one :: Token
one = DigitToken One

two :: Token
two = DigitToken Two

three :: Token
three = DigitToken Three

four :: Token
four = DigitToken Four

five :: Token
five = DigitToken Five

six :: Token
six = DigitToken Six

seven :: Token
seven = DigitToken Seven

eight :: Token
eight = DigitToken Eight

nine :: Token
nine = DigitToken Nine

leftBracketT :: Token
leftBracketT = BracketToken $ LeftBracket "("

rightBracketT :: Token
rightBracketT = BracketToken $ RightBracket ")"

addT :: Token
addT = BinaryToken $ BinaryOp Middle "+" add

subT :: Token
subT = BinaryToken $ BinaryOp Middle "-" sub

multiplyT :: Token
multiplyT = BinaryToken $ BinaryOp High "×" mul

divideT :: Token
divideT = BinaryToken $ BinaryOp High "/" div

exponentT :: Token
exponentT = BinaryToken $ BinaryOp Top "^" pow

modulusT :: Token
modulusT = BinaryToken $ BinaryOp Top "mod" mod

squareRootT :: Token
squareRootT = UnaryToken $ LeftOp "√" sqrt

naturalLogT :: Token
naturalLogT = UnaryToken $ LeftOp "ln" ln

logTenT :: Token
logTenT = UnaryToken $ LeftOp "log₁₀" log10

factorialT :: Token
factorialT = UnaryToken $ RightOp "!" factorial

squareT :: Token
squareT = UnaryToken $ RightOp "^2" (flip pow (fromInt 2))

sinT :: Token
sinT = UnaryToken $ LeftOp "sin" sin

cosT :: Token
cosT = UnaryToken $ LeftOp "cos" cos

tanT :: Token
tanT = UnaryToken $ LeftOp "tan" tan
