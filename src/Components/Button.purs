module Components.Button where

import Prelude

import React.Basic.DOM as DOM
import React.Basic.Events (EventHandler)
import React.Basic.Hooks (Component, component)

type ButtonProps = {
    onClick :: EventHandler,
    icon :: String
}

mkButton :: Component ButtonProps 
mkButton = component "Button" \props -> React.do
    pure $ DOM.button {
        className: "flex items-center justify-center p-4 m-1 text-sky-500 font-bold \
                   \rounded-md hover:bg-sky-200 active:bg-sky-300",
        onClick: props.onClick,
        children: [ DOM.text props.icon ]
    }
