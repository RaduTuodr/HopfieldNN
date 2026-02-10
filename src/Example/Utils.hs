{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-tabs #-}

module Example.Utils where

import Clash.Prelude
import Example.Types

-----------------------
-- Utility functions --
-----------------------

dot :: State -> State -> Acc
dot a b = sum (zipWith (*) a b)

dotWide :: State -> State -> AccWide
dotWide a b = sum (zipWith (\x y -> resize x * resize y) a b)

clampScore :: AccWide -> AccWide
clampScore s =
    if s > 8 then 8
    else if s < (-8) then (-8)
    else s

expLUT :: Vec 17 AccWide
expLUT =
    5  :> 8  :> 13 :> 21 :> 35 :> 57 :> 94 :> 155 :>
    256 :> 422 :> 696 :> 1147 :> 1892 :> 3119 :> 5142 :> 8478 :>
    13977 :> Nil

expApprox :: AccWide -> AccWide
expApprox s =
    let idx = fromIntegral (s + 8) :: Unsigned 5
    in expLUT !! idx

softmaxShift :: Int
softmaxShift = 16

safeDiv :: AccWide -> AccWide -> AccWide
safeDiv num den =
    if den == 0 then 0 else num `div` den

sqError :: State -> State -> AccWide
sqError y t =
    sum (map (\d -> let w = resize d :: AccWide in w*w) (zipWith (-) y t))

linfDist :: State -> State -> Acc
linfDist y t =
    foldl max 0 (map abs (zipWith (-) y t))
