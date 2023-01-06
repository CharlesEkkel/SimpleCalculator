module App where

import Prelude

import React.Basic.DOM as DOM
import React.Basic.DOM.Events (capture_)
import React.Basic.Hooks (Component, component, useState, (/\))
import React.Basic.Hooks as React

type AppProps = Unit

mkApp :: Component AppProps
mkApp = component "App" \_props -> React.do
    counter /\ setCounter <- useState 0

    pure $ DOM.div
        { className: "h-screen w-screen bg-slate-600 flex items-center justify-evenly",
          children: 
            [ DOM.h1_ [ DOM.text "App" ]
            , DOM.p_ [ DOM.text "Try clicking the buuuu!" ]
            , DOM.button
                { onClick: capture_ $ setCounter (_ + 1)
                , children:
                    [ DOM.text "Clicks: "
                    , DOM.text (show counter)
                    ]
                }
            ]
        }
