module Test.LoggyCore (loggycore) where

import Test.Hspec (shouldBe, Spec, describe, it)
import Data.Time

import LoggyCore

inputTime :: String
inputTime = "01:15:00"

inputTimeWith :: String -> String
inputTimeWith = (inputTime ++) 

inputDiffTime :: DiffTime 
inputDiffTime = 4500

dateFormat :: DateFormat 
dateFormat = "%H:%M:%S"

loggycore :: Spec
loggycore = describe "LoggyCoreTest" $ do
    describe "LoggyCore: extractTimestamp" $ do
        it "simpleTimestamp" $ utctDayTime (extractTimestamp dateFormat inputTime) `shouldBe` inputDiffTime
        it "simpleTimestampWithSpaces" $ utctDayTime (extractTimestamp dateFormat $ inputTimeWith " ") `shouldBe` inputDiffTime
        it "simpleTimestampWithExtraChars" $ utctDayTime (extractTimestamp dateFormat $ inputTimeWith " random extra chars") `shouldBe` inputDiffTime   
        it "simpleTimestampWithRepeatedTimestamp" $ utctDayTime (extractTimestamp dateFormat $ inputTimeWith (" " ++ inputTime)) `shouldBe` inputDiffTime
        -- TODO: How to test erroneous input case?
    describe "LoggyCore: mergeLogLines" $ do
        it "bothEmpty" $ mergeLogLines dateFormat [] [] `shouldBe` []
        it "singleEmpty" $ mergeLogLines dateFormat [inputTimeWith " sample log line"] [] `shouldBe` [inputTimeWith " sample log line"]
        it "sameTimeLogs" $ mergeLogLines dateFormat [inputTimeWith " sample log line 1"] [inputTimeWith " sample log line 2"] 
            `shouldBe` [inputTimeWith " sample log line 1", inputTimeWith " sample log line 2"]
        it "mergeDifferentTimeSingleLineLogs" $ mergeLogLines dateFormat [inputTimeWith " from file 1"] ["01:18:00 from file 2"]
            `shouldBe` [inputTimeWith " from file 1", "01:18:00 from file 2"]
        it "mergeDifferentTimeMultiLineLogs" $ mergeLogLines dateFormat [inputTimeWith " from file 1", "01:23:00 from file 1"]
                ["01:18:00 from file 2", "01:25:55 from file 2"]
                    `shouldBe` [inputTimeWith " from file 1", "01:18:00 from file 2", "01:23:00 from file 1", "01:25:55 from file 2"]            


