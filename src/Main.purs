module Main where

import Prelude

import App (mkApp)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM.Client (createRoot, renderRoot)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  root <- getElementById "root" =<< (map toNonElementParentNode $ document =<< window)
  case root of
    Nothing ->
      throw "Root element not found!"
    Just r -> do
      app <- mkApp
      reactRoot <- createRoot r
      renderRoot reactRoot (app unit)
