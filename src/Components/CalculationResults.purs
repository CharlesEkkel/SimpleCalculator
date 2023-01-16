module Components.CalculationResults where

import Prelude

import Data.List (List, take, toUnfoldable)
import Logic.MathTree (Tree, isEmptyTree, renderTree)
import React.Basic.DOM as DOM
import React.Basic.Hooks (Component, component)
import State (AppState)

type CalculationProps = AppState

calculationResults :: Component CalculationProps
calculationResults = component "CalculationResults" \props ->
  pure $ DOM.section
    { className: "rounded-lg bg-sky-100 p-2 min-w-[30%]"
    , children:
        [ DOM.div
            { className: "flex flex-col-reverse items-end"
            , children: listToArray $ props.oldCalculations # take 3 # map \tree ->
                DOM.p
                  { className: "text-5xl m-4 text-sky-600 flex flex-row"
                  , children: [ DOM.text $ renderTreeWithEmptyMessage tree ]
                  }
            }
        , DOM.p
            { className: "text-5xl m-4 text-right"
                <> if isEmptyTree props.currentCalculation then " text-sky-200" else " text-sky-600"
            , children: [ DOM.text $ renderTreeWithEmptyMessage props.currentCalculation ]
            }
        ]
    }

listToArray :: forall a. List a -> Array a
listToArray = toUnfoldable

renderTreeWithEmptyMessage :: Tree -> String
renderTreeWithEmptyMessage tree = case renderTree tree of
  "" -> "Time to calculate..."
  renderedTree -> renderedTree
