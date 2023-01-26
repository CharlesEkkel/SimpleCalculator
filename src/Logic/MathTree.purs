module Logic.MathTree where

import Prelude

import Data.Decimal (Decimal, fromInt)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromJust)
import Logic.Digits (DigitValue, Digits, appendDigit, removeDigit)
import Logic.Digits as Digits
import Partial.Unsafe (unsafePartial)

data Priority = Bottom | Middle | High | Top

derive instance eqPriority :: Eq Priority
derive instance ordPriority :: Ord Priority

data Bracket = LeftBracket String | RightBracket String
data BinaryOp = BinaryOp Priority String (Decimal -> Decimal -> Decimal)
data UnaryOp = LeftOp String (Decimal -> Decimal) | RightOp String (Decimal -> Decimal)

instance Show Bracket where
  show = case _ of
    LeftBracket str -> str
    RightBracket str -> str

instance Show BinaryOp where
  show (BinaryOp _ str _) = " " <> str <> " "

instance Show UnaryOp where
  show = case _ of
    LeftOp str _ -> str
    RightOp str _ -> str

instance Eq BinaryOp where
  eq (BinaryOp priorityA _ _) (BinaryOp priorityB _ _) =
    eq priorityA priorityB

instance Ord BinaryOp where
  compare (BinaryOp priorityA _ _) (BinaryOp priorityB _ _) =
    compare priorityA priorityB

startBrackets :: Tree -> Tree
startBrackets = UnaryNode (LeftOp "" identity)

data Tree
  = BinaryNode BinaryOp Tree Tree
  | UnaryNode UnaryOp Tree
  | NumberLeaf Digits
  | EmptyLeaf

class TreeElement a where
  insert :: a -> Tree -> Tree

isEmptyTree :: Tree -> Boolean
isEmptyTree = case _ of
  EmptyLeaf -> true
  _ -> false

mkSingletonTree :: Decimal -> Tree
mkSingletonTree = NumberLeaf <<< unsafePartial fromJust <<< Digits.fromDecimal 64

-- | Render a tree as a readable, mathematical expression.
renderTree :: Tree -> String
renderTree = case _ of
  EmptyLeaf -> ""
  NumberLeaf precNum -> show precNum
  UnaryNode op child -> case op of
    LeftOp opStr _ -> opStr <> renderTree child
    RightOp opStr _ -> renderTree child <> opStr
  BinaryNode (BinaryOp _ opStr _) l r -> renderTree l <> " " <> opStr <> " " <> renderTree r

-- | Evaluate a pre-built mathematical syntax tree down to a single value.
evaluateTree :: Tree -> Decimal
evaluateTree = case _ of
  EmptyLeaf -> fromInt 0
  NumberLeaf digits -> unsafePartial fromJust $ Digits.toDecimal digits
  BinaryNode (BinaryOp _ _ f) left right -> f (evaluateTree left) (evaluateTree right)
  UnaryNode op child -> case op of
    LeftOp _ f -> f (evaluateTree child)
    RightOp _ f -> f (evaluateTree child)

insertDigit :: DigitValue -> Tree -> Either String Tree
insertDigit digit = case _ of
  EmptyLeaf -> Right $ NumberLeaf $ Digits.singleton digit
  NumberLeaf precNum -> Right $ NumberLeaf $ appendDigit digit precNum
  BinaryNode op left right -> BinaryNode op left <$> insertDigit digit right
  UnaryNode op child -> case op of
    LeftOp _ _ -> UnaryNode op <$> insertDigit digit child
    RightOp opStr _ -> Left $ "A number cannot come after a '" <> opStr <> "'."

insertBinaryOp :: BinaryOp -> Tree -> Either String Tree
insertBinaryOp newOp = case _ of
  EmptyLeaf -> Left "A binary operator must follow a value."
  BinaryNode op left right ->
    if newOp >= op then BinaryNode op left <$> insertBinaryOp newOp right
    else Right $ BinaryNode newOp (BinaryNode op left right) EmptyLeaf
  node -> Right $ BinaryNode newOp node EmptyLeaf

insertUnaryOp :: UnaryOp -> Tree -> Either String Tree
insertUnaryOp newOp = case _ of
  EmptyLeaf -> case newOp of
    LeftOp _ _ -> Right $ UnaryNode newOp EmptyLeaf
    RightOp opStr _ -> Left $ "'" <> opStr <> "' must follow a value, not an operator."
  NumberLeaf precNum -> case newOp of
    LeftOp opStr _ -> Left $ "'" <> opStr <> "' cannot come after a value, only before."
    RightOp _ _ -> Right $ UnaryNode newOp $ NumberLeaf precNum
  BinaryNode op left right -> BinaryNode op left <$> insertUnaryOp newOp right
  UnaryNode op child -> UnaryNode op <$> insertUnaryOp newOp child

-- TODO I don't think brackets quite work yet. May need a new node type.
insertBracket :: Bracket -> Tree -> Either String Tree
insertBracket bracket = case _ of
  EmptyLeaf -> case bracket of
    LeftBracket _ -> Right $ startBrackets EmptyLeaf
    RightBracket _ -> Left "A right bracket must follow a complete expression"
  NumberLeaf precNum -> case bracket of
    LeftBracket _ -> Left "A left bracket cannot follow a value."
    RightBracket _ -> Right $ NumberLeaf precNum
  BinaryNode op left right -> BinaryNode op left <$> insertBracket bracket right
  UnaryNode op child -> UnaryNode op <$> insertBracket bracket child

removeLastToken :: Tree -> Tree
removeLastToken = case _ of
  EmptyLeaf -> EmptyLeaf
  NumberLeaf precNum -> case removeDigit precNum of
    Just num -> NumberLeaf num
    _ -> EmptyLeaf
  UnaryNode f child -> case child of
    EmptyLeaf -> EmptyLeaf
    _ -> UnaryNode f $ removeLastToken child
  BinaryNode f l r -> case r of
    EmptyLeaf -> l
    _ -> BinaryNode f l $ removeLastToken r
