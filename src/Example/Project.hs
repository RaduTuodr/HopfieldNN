{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-tabs #-}

module Example.Project where
import Clash.Prelude
import Example.Hopfield

createDomain vSystem{vName="Dom50", vPeriod=hzToPeriod 50e6}

----------------
-- Top entity --
----------------

topEntity ::
    Clock Dom50 ->
    Reset Dom50 ->
    Enable Dom50 ->
    Signal Dom50 State ->
    Signal Dom50 State
topEntity =
    exposeClockResetEnable hopfieldCore

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
{-# OPAQUE topEntity #-}
