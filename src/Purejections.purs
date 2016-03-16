module Projections where

import Prelude (Unit)
import Control.Monad.Eff (Eff)


foreign import data Projection :: !
foreign import data FoldE :: * -> *

foreign import runProjection :: forall s eff. String -> s -> FoldE s -> Eff (eventFold :: Projection | eff) Unit

foreign import when :: forall e s. String -> (s -> e -> s) -> FoldE s

foreign import foreignAppend :: forall s. FoldE s -> FoldE s -> FoldE s

infix 5 foreignAppend as +++
