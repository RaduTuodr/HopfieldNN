{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-tabs #-}

module Example.Patterns where

import Clash.Prelude
import Example.Types

--------------
-- Patterns --
--------------
p0 :: State
p0 = 384 :> -128 :> 64 :> -256 :> 512 :> 128 :> -64 :> 0 :> 256 :> -192 :> 96 :> 320 :> -32 :> Nil

p1 :: State
p1 = -256 :> 448 :> -96 :> 128 :> -512 :> 64 :> 192 :> -32 :> -128 :> 384 :> -64 :> 0 :> 256 :> Nil

patterns :: Patterns
patterns =
    p0 :> p1 :> Nil
