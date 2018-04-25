module Projections where

import Prelude (Unit, class Semigroup)
import Control.Monad.Eff (Eff, kind Effect)

data EventSource = FromStream String | FromAll | ForEach | FromCategory String | ForEachInCategory String | FromStreams (Array String) | FromStreamMatching

data ProjectionOptions = OutputState String ProjectionOptions | DefaultOptions

outputState :: String -> ProjectionOptions
outputState statename = OutputState statename DefaultOptions

fromStream :: String -> EventSource
fromStream streamname = FromStream streamname

forEach :: EventSource
forEach = ForEach

fromAll :: EventSource
fromAll = FromAll

defaultOptions :: ProjectionOptions
defaultOptions = DefaultOptions

forEachInCategory :: String -> EventSource
forEachInCategory category = ForEachInCategory category

fromCategory :: String -> EventSource
fromCategory category = FromCategory category

fromStreams :: Array String -> EventSource
fromStreams streams = FromStreams streams

foreign import data Projection :: Effect
foreign import data FoldE :: Type -> Type

foreign import runProjection :: forall s eff. EventSource -> s -> ProjectionOptions -> FoldE s -> Eff (eventFold :: Projection | eff) Unit

foreign import when :: forall e s. String -> (s -> e -> s) -> FoldE s

foreign import foreignAppend :: forall s. FoldE s -> FoldE s -> FoldE s

foreign import whenAny :: forall e s. (s -> e -> s) -> FoldE s

instance semigroupFoldE :: Semigroup (FoldE s) where
append = foreignAppend
