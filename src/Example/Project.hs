-- @createDomain@ below generates a warning about orphan instances, but we like
-- our code to be warning-free.
{-# OPTIONS_GHC -Wno-orphans #-}

{-# OPTIONS_GHC -Wno-tabs #-}

module Example.Project where

import Clash.Prelude

-- Create a domain with the frequency of your input clock. For this example we used
-- 50 MHz.
createDomain vSystem{vName="Dom50", vPeriod=hzToPeriod 50e6}

-- Type:
type Dim	= 13
type F 		= Signed 16
type VecD 	= Vec Dim F
type Acc 	= Signed 32

p0 :: VecD
p0 = 1 :> -28 :> -11 :> 0 :> 107 :> 1 :> 137 :> 4 :> 102 :> 41 :> 50 :> 83 :> 111 :> Nil

p1 :: VecD
p1 = -6 :> 107 :> 43 :> 3 :> 66 :> -6 :> 130 :> -18 :> 74 :> 74 :> 38 :> 105 :> 82 :> Nil

dot :: VecD -> VecD -> Acc
dot a b = sum (zipWith mull a b)
	where
		mull :: F -> F -> Acc
		mull x y = resize (x * y)

classify :: VecD -> Bit
classify x =
  let
    s0 = dot x p0
    s1 = dot x p1
  in
    if s1 > s0 then 1 else 0

-- | @topEntity@ is Clash@s equivalent of @main@ in other programming languages.
-- Clash will look for it when compiling "Example.Project" and translate it to
-- HDL. While polymorphism can be used freely in Clash projects, a @topEntity@
-- must be monomorphic and must use non- recursive types. Or, to put it
-- hand-wavily, a @topEntity@ must be translatable to a static number of wires.
--
-- Top entities must be monomorphic, meaning we have to specify all type variables.
-- In this case, we are using the @Dom50@ domain, which we created with @createDomain@
-- and we are using 8-bit unsigned numbers.
topEntity ::
  Clock Dom50 ->
  Reset Dom50 ->
  Enable Dom50 ->
  Signal Dom50 VecD ->
  Signal Dom50 Bit
topEntity = exposeClockResetEnable (fmap classify)

-- To specify the names of the ports of our top entity, we create a @Synthesize@ annotation.
{-# ANN topEntity
  (Synthesize
    { t_name = "hopular_classifier"
    , t_inputs = [ PortName "CLK"
                 , PortName "RST"
                 , PortName "EN"
                 , PortName "X"
                 ]
    , t_output = PortName "CLASS"
    }) #-}

-- Make sure GHC does not apply any optimizations to the boundaries of the design.
-- For GHC versions 9.2 or older, use: {-# NOINLINE topEntity #-}
{-# OPAQUE topEntity #-}
