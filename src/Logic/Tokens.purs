module Logic.Tokens where

import Prelude

import Data.Either (Either)
import Data.Number (cos, log, pow, sin, sqrt, tan)
import Logic.MathTree (BinaryOp(..), Bracket(..), Priority(..), Tree, UnaryOp(..), Value(..), insertBinaryOp, insertBracket, insertUnaryOp, insertValue)
import Utils.Maths (factorial)
import Utils.Maths as M

data Token = TBracket Bracket | TBinaryOp BinaryOp | TUnaryOp UnaryOp | TValue Value

instance Show Token where
  show = case _ of
    TBracket bracket -> show bracket
    TBinaryOp binaryOp -> show binaryOp
    TUnaryOp unaryOp -> show unaryOp
    TValue value -> show value

insertToken :: Token -> Tree -> Either String Tree
insertToken token tree = case token of
  TBracket bracket -> insertBracket bracket tree
  TBinaryOp op -> insertBinaryOp op tree
  TUnaryOp op -> insertUnaryOp op tree
  TValue value -> insertValue value tree

mkValueT :: Int -> Token
mkValueT = TValue <<< Value

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
naturalLogT = TUnaryOp $ LeftOp "ln" log

logTenT :: Token
logTenT = TBinaryOp $ BinaryOp Top "log₁₀" M.log

factorialT :: Token
factorialT = TUnaryOp $ RightOp "!" factorial

squareT :: Token
squareT = TUnaryOp $ RightOp "" (flip pow 2.0)

sinT :: Token
sinT = TUnaryOp $ LeftOp "sin" sin

cosT :: Token
cosT = TUnaryOp $ LeftOp "cos" cos

tanT :: Token
tanT = TUnaryOp $ LeftOp "tan" tan
