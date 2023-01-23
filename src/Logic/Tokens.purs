module Logic.Tokens where

import Prelude

import Data.Either (Either)
import Data.Decimal (cos, factorial, fromInt, ln, log10, pow, sin, sqrt, tan)
import Logic.MathTree (BinaryOp(..), Bracket(..), Priority(..), Tree, UnaryOp(..), insertBinaryOp, insertBracket, insertDigit, insertUnaryOp)
import Logic.Digits (Digit)

data Token = TBracket Bracket | TBinaryOp BinaryOp | TUnaryOp UnaryOp | TDigit Digit

instance Show Token where
  show = case _ of
    TBracket bracket -> show bracket
    TBinaryOp binaryOp -> show binaryOp
    TUnaryOp unaryOp -> show unaryOp
    TDigit digit -> show digit

insertToken :: Token -> Tree -> Either String Tree
insertToken token tree = case token of
  TBracket bracket -> insertBracket bracket tree
  TBinaryOp op -> insertBinaryOp op tree
  TUnaryOp op -> insertUnaryOp op tree
  TDigit digit -> insertDigit digit tree

mkDigitT :: Digit -> Token
mkDigitT = TDigit

leftBracketT :: Token
leftBracketT = TBracket $ LeftBracket "("

rightBracketT :: Token
rightBracketT = TBracket $ RightBracket ")"

addT :: Token
addT = TBinaryOp $ BinaryOp Middle "+" add

subT :: Token
subT = TBinaryOp $ BinaryOp Middle "-" sub

multiplyT :: Token
multiplyT = TBinaryOp $ BinaryOp High "×" mul

divideT :: Token
divideT = TBinaryOp $ BinaryOp High "/" div

exponentT :: Token
exponentT = TBinaryOp $ BinaryOp Top "^" pow

modulusT :: Token
modulusT = TBinaryOp $ BinaryOp Top "mod" mod

squareRootT :: Token
squareRootT = TUnaryOp $ LeftOp "√" sqrt

naturalLogT :: Token
naturalLogT = TUnaryOp $ LeftOp "ln" ln

logTenT :: Token
logTenT = TUnaryOp $ LeftOp "log₁₀" log10

factorialT :: Token
factorialT = TUnaryOp $ RightOp "!" factorial

squareT :: Token
squareT = TUnaryOp $ RightOp "^2" (flip pow (fromInt 2))

sinT :: Token
sinT = TUnaryOp $ LeftOp "sin" sin

cosT :: Token
cosT = TUnaryOp $ LeftOp "cos" cos

tanT :: Token
tanT = TUnaryOp $ LeftOp "tan" tan
