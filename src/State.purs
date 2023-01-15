module State where

import Prelude

import Data.Either (Either(..))
import Data.List (List(..), (:))
import Data.Maybe (Maybe(..))
import Logic.MathTree (Tree(..), evaluateTree, mkSingletonTree, removeLastToken)
import Logic.Tokens (Token, insertToken)

type AppState = {
  oldCalculations :: List Tree,
  currentCalculation :: Tree,
  isRadiansEnabled :: Boolean,
  errorMessage :: Maybe String
}

initialState :: AppState
initialState = {
  oldCalculations: Nil,
  currentCalculation: EmptyLeaf,
  isRadiansEnabled: false,
  errorMessage: Nothing
}

data Action = 
  AddToken Token
  | RunEquals
  | ClearCurrent
  | ClearAll
  | Backspace
  | ToggleRadians

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

  Backspace -> 
    state {
      currentCalculation = removeLastToken state.currentCalculation
    }

  ToggleRadians -> 
    state {
      isRadiansEnabled = not state.isRadiansEnabled
    }

