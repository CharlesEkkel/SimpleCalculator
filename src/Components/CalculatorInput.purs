module Components.CalculatorInput where

import Prelude hiding (one, zero)

import Components.Button (mkButton)
import Logic.MathTree (Token, renderToken)
import Logic.Tokens (addT, cosT, divideT, eight, exponentT, factorialT, five, four, leftBracketT, logTenT, modulusT, multiplyT, naturalLogT, nine, one, rightBracketT, seven, sinT, six, squareRootT, squareT, subT, tanT, three, two, zero)
import React.Basic.DOM as DOM
import React.Basic.Events (EventHandler)
import React.Basic.Hooks (Component, component)

type CalcInputProps =
  { runAddToken :: Token -> EventHandler
  , runEquals :: EventHandler
  , runClear :: EventHandler
  , runClearAll :: EventHandler
  , runBackspace :: EventHandler
  , runToggleRadians :: EventHandler
  , isRadiansEnabled :: Boolean
  }

calculatorInput :: Component CalcInputProps
calculatorInput = do

  button <- mkButton

  component "CalculatorInput" \(props :: CalcInputProps) -> React.do

    let
      mkTokenButton token = button { onClick: props.runAddToken token, icon: renderToken token }

    pure $ DOM.section
      { className: "grid grid-cols-5 grid-rows-7 bg-sky-100 rounded-lg"
      , children:
          [ button { onClick: props.runClearAll, icon: "CA" }
          , button { onClick: props.runClear, icon: "C" }
          , button { onClick: props.runBackspace, icon: "<" }
          , DOM.div_ []
          , button { onClick: props.runToggleRadians, icon: if props.isRadiansEnabled then "Rad" else "Deg" }
          ]
            <>
              map mkTokenButton
                [ sinT
                , cosT
                , tanT
                , naturalLogT
                , logTenT
                , squareRootT
                , leftBracketT
                , rightBracketT
                , modulusT
                , factorialT
                , divideT
                , seven
                , eight
                , nine
                , multiplyT
                , multiplyT -- Should be 'e'
                , four
                , five
                , six
                , subT
                , exponentT
                , one
                , two
                , three
                , addT
                , squareT
                , zero
                ]
            <>
              [ button { onClick: props.runEquals, icon: "=" }
              ]
      }
