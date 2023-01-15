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

  component "App" \_props -> React.do
    
    appState /\ dispatch <- useReducer initialState reducer  

    pure $ DOM.div
        { className: "h-screen w-screen bg-slate-600 flex items-center justify-evenly",
          children: 
          [ elCalculationResults appState,
            elCalculatorInput {
              addToken: capture_ <<< dispatch <<< AddToken,
              runEquals: capture_ $ dispatch RunEquals,
              clear: capture_ $ dispatch ClearCurrent,
              clearAll: capture_ $ dispatch ClearAll
            }
          ]
        }
