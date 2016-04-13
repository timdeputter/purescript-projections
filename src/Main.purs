module Main where

import Prelude (Unit, (+), ($), (<>))
import Control.Monad.Eff (Eff)
import Projections (Projection, when, whenAny, runProjection, fromAll, fromStream, forEachInCategory, fromStreams)

-- Example state type
type State = {count :: Int}

type TypA = {event :: String}

handlerA :: State -> TypA -> State
handlerA s e = {count: s.count+1}

handlerB :: State -> TypA -> State
handlerB s e = {count: s.count+1}

fromAllProjections :: forall t9. Eff ( eventFold :: Projection | t9) Unit
fromAllProjections = runProjection fromAll {count:0} $ when "$statsCollected" handlerA 

fromStreamProjections :: forall t9. Eff ( eventFold :: Projection | t9) Unit
fromStreamProjections = runProjection (fromStream "figo") {count:0} $ when "$statsCollected" handlerA <> when "Figo" handlerB

forEachInCategoryProjections :: forall t9. Eff ( eventFold :: Projection | t9) Unit
forEachInCategoryProjections = runProjection (forEachInCategory "figo") {count:0} $ when "$statsCollected" handlerA <> when "Figo" handlerB

fromStreamsProjections :: forall t9. Eff ( eventFold :: Projection | t9) Unit
fromStreamsProjections = runProjection (fromStreams ["figo", "gofi"]) {count:0} $ when "$statsCollected" handlerA <> when "Figo" handlerB

whenAnyEvent :: forall t. Eff (eventFold :: Projection | t) Unit
whenAnyEvent = runProjection fromAll {count:0} $ whenAny handlerA

main :: forall t9. Eff ( eventFold :: Projection | t9) Unit
main = whenAnyEvent
