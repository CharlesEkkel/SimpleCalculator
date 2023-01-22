module App where

import Prelude

import Components.CalculationResults (calculationResults)
import Components.CalculatorInput (calculatorInput)
import React.Basic.DOM as DOM
import React.Basic.DOM.Events (capture_)
import React.Basic.Hooks (Component, component, mkReducer, useReducer, (/\))
import React.Basic.Hooks as React
import State (Action(..), appReducer, initialState)

type AppProps = Unit

mkApp :: Component AppProps
mkApp = do
  elCalculationResults <- calculationResults
  elCalculatorInput <- calculatorInput

  reducer <- mkReducer appReducer

  -- message <- getRandomHintMessage

  component "App" \_props -> React.do

    appState /\ dispatch <- useReducer initialState reducer

    pure $ DOM.div
      { className: "h-screen w-screen bg-slate-600 flex items-center justify-evenly"
      , children:
          [ elCalculationResults appState
          , elCalculatorInput
              { runAddToken: capture_ <<< dispatch <<< AddToken
              , runEquals: capture_ $ dispatch RunEquals
              , runClear: capture_ $ dispatch ClearCurrent
              , runClearAll: capture_ $ dispatch ClearAll
              , runBackspace: capture_ $ dispatch Backspace
              , runToggleRadians: capture_ $ dispatch ToggleRadians
              , isRadiansEnabled: appState.isRadiansEnabled
              }
          ]
      }
