module State where

import Prelude

import Data.Either (Either(..))
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Logic.MathTree (Tree(..), evaluateTree, mkSingletonTree)
import Logic.Tokens (Token, insertToken)

type AppState = {
  oldCalculations :: List Tree,
  currentCalculation :: Tree,
  errorMessage :: Maybe String
}

initialState :: AppState
initialState = {
  oldCalculations: Nil,
  currentCalculation: EmptyLeaf,
  errorMessage: Nothing
}

data Action = 
  AddToken Token
  | RunEquals
  | ClearCurrent
  | ClearAll

appReducer :: AppState -> Action -> AppState
appReducer state = case _ of
  AddToken t -> 
    case insertToken t state.currentCalculation of 
      Right tree -> state { currentCalculation = tree }
      Left err -> state { errorMessage = Just err }

  RunEquals -> 
    state {
      currentCalculation = mkSingletonTree $ evaluateTree state.currentCalculation,
      oldCalculations = state.currentCalculation : state.oldCalculations 
    }

  ClearCurrent -> 
    state {
      currentCalculation = EmptyLeaf
    }

  ClearAll -> 
    state {
      currentCalculation = EmptyLeaf,
      oldCalculations = Nil
    }

