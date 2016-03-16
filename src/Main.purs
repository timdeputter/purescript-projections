module Main where

import Prelude (Unit, (+), ($))
import Control.Monad.Eff (Eff)
import Projections (Projection, when, (+++), runProjection)

-- Example state type
type State = {count :: Int}

type TypA = {event :: String}

handlerA :: State -> TypA -> State
handlerA s e = {count: s.count+1}

handlerB :: State -> TypA -> State
handlerB s e = {count: s.count+1}

main :: forall t9. Eff ( eventFold :: Projection | t9) Unit
main = runProjection "Figo" {count:0} $ when "Hello" handlerA +++ when "Figo" handlerB
