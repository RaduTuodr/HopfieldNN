{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-tabs #-}

module Example.Types where

import Clash.Prelude

--------------------------
-- Types and parameters --
--------------------------

createDomain vSystem{vName="Dom50", vPeriod=hzToPeriod 50e6}

type Dim   = 13
type Acc   = Signed 16
type AccWide = Signed 32
type State = Vec Dim Acc
type NumPats = 2
type Patterns = Vec NumPats State
type Iter = Unsigned 4
