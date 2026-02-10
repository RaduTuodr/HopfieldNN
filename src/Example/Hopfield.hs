{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-tabs #-}

module Example.Hopfield where

import Clash.Prelude
import Example.Types
import Example.Patterns
import Example.Utils

----------------------------------------------------------------------
-- Modern Hopfield update step (softmax attention)
----------------------------------------------------------------------

hopfieldStep :: Patterns -> State -> State
hopfieldStep pats x =
    let scores = map (`dotWide` x) pats
        scoresScaled = map (clampScore . (`shiftR` softmaxShift)) scores
        exps = map expApprox scoresScaled
        sumExp = sum exps
        col i = map (\p -> p !! i) pats
        combine i =
            let ws = zipWith
                        (\e p -> (resize e :: AccWide) * (resize p :: AccWide))
                        exps
                        (col i)
                wsum = sum ws
                out = safeDiv wsum sumExp
            in resize out :: Acc
    in imap (\i _ -> combine i) x

----------------------------------------------------------------------
-- Sequential core (1 iteration/clock)
----------------------------------------------------------------------

hopfieldCore ::
    HiddenClockResetEnable Dom50 =>
    Signal Dom50 State ->
    Signal Dom50 State
hopfieldCore x0 =
    mealy step initState x0
    where
        maxIter :: Iter
        maxIter = 8
        initState = (repeat 0, 0 :: Iter)
        step (st, it) x =
            if x /= st then
                ((x, 0), x)
            else
                let st' = hopfieldStep patterns st
                    done = st' == st || it == maxIter
                    it' = if done then it else it + 1
                in ((st', it'), st')
