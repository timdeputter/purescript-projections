module Projections where

import Prelude (Unit, class Semigroup)
import Control.Monad.Eff (Eff)

data EventSource = FromStream String | FromAll | ForEachInCategory String | FromStreams (Array String)

fromStream :: String -> EventSource
fromStream streamname = FromStream streamname

fromAll :: EventSource
fromAll = FromAll

forEachInCategory :: String -> EventSource
forEachInCategory category = ForEachInCategory category

fromStreams :: Array String -> EventSource
fromStreams streams = FromStreams streams

foreign import data Projection :: !
foreign import data FoldE :: * -> *

foreign import runProjection :: forall s eff. EventSource -> s -> FoldE s -> Eff (eventFold :: Projection | eff) Unit

foreign import when :: forall e s. String -> (s -> e -> s) -> FoldE s

foreign import foreignAppend :: forall s. FoldE s -> FoldE s -> FoldE s

instance semigroupFoldE :: Semigroup (FoldE s) where
append = foreignAppend
