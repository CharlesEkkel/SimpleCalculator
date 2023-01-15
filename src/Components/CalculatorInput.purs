module Components.CalculatorInput where

import Prelude

import Components.Button (mkButton)
import Data.Array ((..))
import Logic.Tokens (Token, mkValueT)
import React.Basic.DOM as DOM
import React.Basic.Events (EventHandler)
import React.Basic.Hooks (Component, component)

type CalcInputProps = {
  runAddToken :: Token -> EventHandler,
  runEquals :: EventHandler,
  runClear :: EventHandler,
  runClearAll :: EventHandler,
  runBackspace :: EventHandler,
  runToggleRadians :: EventHandler,
  isRadiansEnabled :: Boolean
}

calculatorInput :: Component CalcInputProps
calculatorInput = do

  button <- mkButton
  
  component "CalculatorInput" \props -> React.do
    pure $ DOM.section {
        className: "grid grid-cols-5 grid-rows-7 bg-sky-100 rounded-lg",
        children: 
            [ button { onClick: props.runClearAll, icon: "CA" },
              button { onClick: props.runClear, icon: "C" },
              button { onClick: props.runBackspace, icon: "<" },
              DOM.div_ [],
              button { onClick: props.runToggleRadians, icon: if props.isRadiansEnabled then "Rad" else "Deg" },
              button { onClick: props.runEquals, icon: "=" }
            ]

            <> (0..9 # map \x -> 
              let token = mkValueT x
               in button { onClick: props.runAddToken token, icon: show token } )
    }
