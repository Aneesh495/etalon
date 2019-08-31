implementation module Etalon.Tests.TestSyndromeDecoding

/*
 * TestSyndromeDecoding.icl: Syndrome computation and error detection in BCH/RS codewords test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSyndromeDecoding
import Etalon.Otn.SyndromeDecoder


testSyndromeEvaluation :: TestCaseResult
testSyndromeEvaluation =
    let cleanCodeword = [0 \ _ <- [1..255]]
        res = decodeCodewordFull cleanCodeword 16
        a1 = assertBool "Clean codeword succeeds with 0 errors" True (case res.status of DecoderSuccess 0 -> True; _ -> False)
    in makeCaseResult "testSyndromeEvaluation" [a1] 0.4


runSuiteTestSyndromeDecoding :: TestSuiteResult
runSuiteTestSyndromeDecoding =
    makeSuiteResult "TestSyndromeDecoding" [testSyndromeEvaluation]
