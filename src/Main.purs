module Main where

import Prelude (Unit, (+), ($))
import Control.Monad.Eff (Eff)
import Projections (Projection, fromAll, fromCategory, fromStream, fromStreams, runProjection, when, whenAny, defaultOptions, outputState)

-- Example state type
type State = {count :: Int}

type TypA = {event :: String}

handlerA :: State -> TypA -> State
handlerA s e = {count: s.count+1}

handlerB :: State -> TypA -> State
handlerB s e = {count: s.count+1}

fromAllProjections :: forall t9. Eff ( eventFold :: Projection | t9) Unit
fromAllProjections = runProjection fromAll {count:0} defaultOptions $ when "$statsCollected" handlerA 

fromStreamProjections :: forall t9. Eff ( eventFold :: Projection | t9) Unit
fromStreamProjections = runProjection (fromStream "$stats-127.0.0.1:2113") {count:0} defaultOptions $ when "$statsCollected" handlerA

forEachInCategoryProjections :: forall t9. Eff ( eventFold :: Projection | t9) Unit
forEachInCategoryProjections = runProjection (fromCategory "$stats") {count:0} defaultOptions $ when "$statsCollected" handlerA

fromStreamsProjections :: forall t9. Eff ( eventFold :: Projection | t9) Unit
fromStreamsProjections = runProjection (fromStreams ["$stats-127.0.0.1:2113", "$projections-$master"]) {count:0} defaultOptions $ when "$statsCollected" handlerA

whenAnyEvent :: forall t. Eff (eventFold :: Projection | t) Unit
whenAnyEvent = runProjection fromAll {count:0} defaultOptions $ whenAny handlerA

outputStateProjection :: forall t. Eff (eventFold :: Projection | t) Unit
outputStateProjection = runProjection fromAll {count:0} (outputState "Zustand") $ whenAny handlerA

main :: forall t9. Eff ( eventFold :: Projection | t9) Unit
main = outputStateProjection 
