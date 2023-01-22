module Components.CalculatorInput where

import Prelude

import Components.Button (mkButton)
import Data.Array ((..))
import Data.Enum (enumFromTo)
import Data.Int (toNumber)
import Data.Number (e)
import Logic.Digits (Digit(..))
import Logic.Tokens (Token, addT, cosT, divideT, exponentT, factorialT, leftBracketT, logTenT, mkDigitT, modulusT, multiplyT, naturalLogT, rightBracketT, sinT, squareRootT, squareT, subT, tanT)
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

  component "CalculatorInput" \props -> React.do

    let
      mkTokenButton token = button { onClick: props.runAddToken token, icon: show token }

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
                ]

            <>
              map (mkTokenButton <<< mkDigitT) (Seven `enumFromTo` Nine)

            <>
              map mkTokenButton
                [ multiplyT
                -- , mkDigitT e
                ]

            <>
              map (mkTokenButton <<< mkDigitT) (Four `enumFromTo` Six)

            <>
              map mkTokenButton
                [ subT
                , exponentT
                ]

            <>
              map (mkTokenButton <<< mkDigitT) (One `enumFromTo` Three)

            <>
              map mkTokenButton
                [ addT
                , squareT
                , mkDigitT Zero
                ]

            <> [ button { onClick: props.runEquals, icon: "=" } ]
      }
