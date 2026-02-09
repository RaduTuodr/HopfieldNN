module Tests.Example.Project where

import Prelude

import Test.Tasty
import Test.Tasty.Hedgehog
import qualified Hedgehog as H

import qualified Clash.Prelude as C

-- Import the module containing the @classify@ function
import Example.Project (classify)
import Example.TestVectors (testsNotExited, testsExited)

-- Helper function to count correct classifications
countCorrect :: (C.KnownNat n) => C.Vec n C.Bit -> C.Bit -> Int
countCorrect results expected =
  length $ filter (== expected) (C.toList results)

-- Helper to calculate accuracy percentage
accuracy :: Int -> Int -> Double
accuracy correct total = (fromIntegral correct / fromIntegral total) * 100

prop_notExited :: H.Property
prop_notExited = H.property $ do
  let results = C.map classify testsNotExited
      correct = countCorrect results 0
      total = 1000
      acc = accuracy correct total

  H.annotate $ "Accuracy: " ++ show acc ++ "% (" ++ show correct ++ "/" ++ show total ++ ")"
  H.assert (acc >= 50.0)  -- Require at least 50% accuracy

prop_Exited :: H.Property
prop_Exited = H.property $ do
  let results = C.map classify testsExited
      correct = countCorrect results 1
      total = 407
      acc = accuracy correct total

  H.annotate $ "Accuracy: " ++ show acc ++ "% (" ++ show correct ++ "/" ++ show total ++ ")"
  H.assert (acc >= 50.0)  -- Require at least 50% accuracy

-- Combined accuracy test
prop_overallAccuracy :: H.Property
prop_overallAccuracy = H.property $ do
  let results0 = C.map classify testsNotExited
      results1 = C.map classify testsExited
      correct0 = countCorrect results0 0
      correct1 = countCorrect results1 1
      totalCorrect = correct0 + correct1
      total = 1000 + 407
      acc = accuracy totalCorrect total

  H.annotate $ "Overall Accuracy: " ++ show acc ++ "% (" ++ show totalCorrect ++ "/" ++ show total ++ ")"
  H.annotate $ "Class 0 (not exited): " ++ show correct0 ++ "/1000"
  H.annotate $ "Class 1 (exited): " ++ show correct1 ++ "/407"
  H.assert (acc >= 50.0)  -- Require at least 50% overall accuracy

tests :: TestTree
tests = testGroup "Hopular tests"
  [ testProperty "Not-exited classification accuracy" prop_notExited
  , testProperty "Exited classification accuracy"     prop_Exited
  , testProperty "Overall classification accuracy"    prop_overallAccuracy
  ]

main :: IO ()
main = defaultMain tests
