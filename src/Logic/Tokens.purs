module Logic.Tokens where

import Prelude

import Data.Either (Either)
import Data.Number (pow, sqrt)
import Logic.MathTree (BinaryOp(..), Bracket(..), Priority(..), Tree, UnaryOp(..), Value(..), insertBinaryOp, insertBracket, insertUnaryOp, insertValue)

data Token = TBracket Bracket | TBinaryOp BinaryOp | TUnaryOp UnaryOp | TValue Value

insertToken :: Token -> Tree -> Either String Tree
insertToken token tree = case token of
  TBracket bracket -> insertBracket bracket tree
  TBinaryOp op -> insertBinaryOp op tree
  TUnaryOp op -> insertUnaryOp op tree
  TValue value -> insertValue value tree

mkValueT :: Number -> Token
mkValueT = TValue <<< Value

leftBracketT :: Token
leftBracketT = TBracket $ LeftBracket "("

rightBracketT :: Token
rightBracketT = TBracket $ RightBracket ")"

addT :: Token
addT = TBinaryOp $ BinaryOp Middle "+" add 

subT = TBinaryOp $ BinaryOp Middle "-" sub

multiplyT = TBinaryOp $ BinaryOp High "×" mul

divideT = TBinaryOp $ BinaryOp High "/" div

exponentT = TBinaryOp $ BinaryOp Top "^" pow

modulusT = TBinaryOp $ BinaryOp Top "mod" mod

squareRootT :: Token
squareRootT = TUnaryOp $ LeftOp "√" sqrt
