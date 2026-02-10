{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-tabs #-}

module Example.Project where
import Clash.Prelude

createDomain vSystem{vName="Dom50", vPeriod=hzToPeriod 50e6}

--------------------------
-- Types and parameters --
--------------------------
type Dim   = 13
type Acc   = Signed 16
type AccWide = Signed 32
type State = Vec Dim Acc
type NumPats = 2
type Patterns = Vec NumPats State
type Iter = Unsigned 4

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

----------------------------------------------------------------------
-- Modern Hopfield update step (softmax attention, fixed-point)
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
-- Sequential core (1 iteration per clock)
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

----------------------------------------------------------------------
-- Top entity
----------------------------------------------------------------------

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
