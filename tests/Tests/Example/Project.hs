module Tests.Example.Project where

-- import Prelude

-- import Test.Tasty
-- import Test.Tasty.Hedgehog
-- import qualified Hedgehog as H

-- import qualified Clash.Prelude as C

-- -- Import the module containing the @classify@ function
-- import Example.Project (classify)
-- import Example.TestVectors (testsNotExited, testsExited)

-- -- Helper function to count correct classifications
-- countCorrect :: (C.KnownNat n) => C.Vec n C.Bit -> C.Bit -> Int
-- countCorrect results expected =
--   length $ filter (== expected) (C.toList results)

-- -- Helper to calculate accuracy percentage
-- accuracy :: Int -> Int -> Double
-- accuracy correct total =
--   (fromIntegral correct / fromIntegral total) * 100

-- prop_notExited :: H.Property
-- prop_notExited = H.property $ do
--   let results = C.map classify testsNotExited
--       correct = countCorrect results 0
--       total = 1000
--       acc = accuracy correct total

--   H.annotate $ "Accuracy: " ++ show acc ++ "% (" ++ show correct ++ "/" ++ show total ++ ")"
--   H.assert (acc >= 50.0)

-- prop_Exited :: H.Property
-- prop_Exited = H.property $ do
--   let results = C.map classify testsExited
--       correct = countCorrect results 1
--       total = 407
--       acc = accuracy correct total

--   H.annotate $ "Accuracy: " ++ show acc ++ "% (" ++ show correct ++ "/" ++ show total ++ ")"
--   H.assert (acc >= 50.0)

-- prop_overallAccuracy :: H.Property
-- prop_overallAccuracy = H.property $ do
--   let results0 = C.map classify testsNotExited
--       results1 = C.map classify testsExited
--       correct0 = countCorrect results0 0
--       correct1 = countCorrect results1 1
--       totalCorrect = correct0 + correct1
--       total = 1000 + 407
--       acc = accuracy totalCorrect total

--   H.annotate $ "Overall Accuracy: " ++ show acc ++ "% (" ++ show totalCorrect ++ "/" ++ show total ++ ")"
--   H.assert (acc >= 50.0)

-- printAccuracyReport :: IO ()
-- printAccuracyReport = do
--   let results0 = C.map classify testsNotExited
--       results1 = C.map classify testsExited

--       correct0 = countCorrect results0 0
--       correct1 = countCorrect results1 1

--       total0 = 1000
--       total1 = 407

--       acc0 = accuracy correct0 total0
--       acc1 = accuracy correct1 total1
--       accAll = accuracy (correct0 + correct1) (total0 + total1)

--   putStrLn ""
--   putStrLn "==== Classification accuracy report ===="
--   putStrLn $ "Class 0 (not exited): " ++ show acc0 ++ "% (" ++ show correct0 ++ "/" ++ show total0 ++ ")"
--   putStrLn $ "Class 1 (exited):     " ++ show acc1 ++ "% (" ++ show correct1 ++ "/" ++ show total1 ++ ")"
--   putStrLn $ "Overall accuracy:    " ++ show accAll ++ "%"
--   putStrLn "========================================"

-- tests :: TestTree
-- tests = testGroup "Hopular tests"
--   [ testProperty "Not-exited classification accuracy" prop_notExited
--   , testProperty "Exited classification accuracy"     prop_Exited
--   , testProperty "Overall classification accuracy"    prop_overallAccuracy
--   ]

-- main :: IO ()
-- main = do
--   printAccuracyReport
--   defaultMain tests
