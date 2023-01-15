module Components.CalculatorInput where

import Prelude

import Logic.Tokens (Token)
import React.Basic.DOM as DOM
import React.Basic.Events (EventHandler)
import React.Basic.Hooks (Component, component)

type CalcInputProps = {
  addToken :: Token -> EventHandler,
  runEquals :: EventHandler,
  clear :: EventHandler,
  clearAll :: EventHandler
}

calculatorInput :: Component CalcInputProps
calculatorInput = do
  
  component "CalculatorInput" \_props -> React.do
    pure $ DOM.section {
        className: "grid grid-cols-5 grid-rows-7 bg-sky-100 rounded-lg",
        children: [
            DOM.button_ [ DOM.text "Click me!" ]
        ]
    }
