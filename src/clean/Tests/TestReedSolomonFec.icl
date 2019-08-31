implementation module Etalon.Tests.TestReedSolomonFec

/*
 * TestReedSolomonFec.icl: ITU-T G.709 16-way interleaved RS(255, 239) encoding test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestReedSolomonFec
import Etalon.Otn.Fec
import Etalon.Otn.Frame


testRsEncodingCodeword :: TestCaseResult
testRsEncodingCodeword =
    let msg = [0 \ _ <- [1..239]]
        cw = rsEncodeCodeword msg
        a1 = assertIntEq "Codeword length is 255" 255 (length cw)
        f0 = createOtnFrame Otu1 1
        f1 = encodeOtnFrameFec f0
        a2 = assertBool "Frame is marked fecEncoded" True f1.fecEncoded
    in makeCaseResult "testRsEncodingCodeword" [a1, a2] 0.8


runSuiteTestReedSolomonFec :: TestSuiteResult
runSuiteTestReedSolomonFec =
    makeSuiteResult "TestReedSolomonFec" [testRsEncodingCodeword]
