module Projections where

import Prelude 
import Control.Monad.Eff (Eff, kind Effect)


type ProjectionOptions = {resultStreamName:: String, outputState:: Boolean}

type FromStreamsOptions = {processingLag:: Int, reorderEvents :: Boolean}

data EventSource = FromStream String | FromAll | ForEach | FromCategory String | ForEachInCategory String | FromStreams FromStreamsOptions (Array String) | FromStreamMatching

outputState :: String -> ProjectionOptions
outputState streamname = {resultStreamName: streamname, outputState: true}

fromStream :: String -> EventSource
fromStream streamname = FromStream streamname

forEach :: EventSource
forEach = ForEach

fromAll :: EventSource
fromAll = FromAll

defaultOptions :: ProjectionOptions
defaultOptions = {resultStreamName: "", outputState: false}

forEachInCategory :: String -> EventSource
forEachInCategory category = ForEachInCategory category

fromCategory :: String -> EventSource
fromCategory category = FromCategory category

fromStreams :: Array String -> EventSource
fromStreams streams = FromStreams {processingLag: 500, reorderEvents: false} streams

fromStreamsWithReordering :: Int -> Array String -> EventSource
fromStreamsWithReordering lag streams = FromStreams {processingLag: lag, reorderEvents: true} streams

foreign import data Projection :: Effect
foreign import data FoldE :: Type -> Type

foreign import runProjection :: forall s eff. EventSource -> s -> ProjectionOptions -> FoldE s -> Eff (eventFold :: Projection | eff) Unit

foreign import when :: forall e s. String -> (s -> e -> s) -> FoldE s

foreign import foreignAppend :: forall s. FoldE s -> FoldE s -> FoldE s

foreign import whenAny :: forall e s. (s -> e -> s) -> FoldE s

instance semigroupFoldE :: Semigroup (FoldE s) where
append = foreignAppend
