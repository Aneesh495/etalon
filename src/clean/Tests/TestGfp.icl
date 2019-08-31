implementation module Etalon.Tests.TestGfp

/*
 * TestGfp.icl: Generic Framing Procedure encapsulation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGfp
import Etalon.Otn.GfpFramer


testGfpEncapsulation :: TestCaseResult
testGfpEncapsulation =
    let frame = buildGfpIdleFrame
        a1 = assertBool "Idle frame core HEC is valid" True frame.coreHecOk
        crc = computeCrc16 [0x00, 0x01, 0x02, 0x03]
        a2 = assertBool "CRC-16 is non-zero" True (crc <> 0)
    in makeCaseResult "testGfpEncapsulation" [a1, a2] 0.4

runSuiteTestGfp :: TestSuiteResult
runSuiteTestGfp = makeSuiteResult "TestGfp" [testGfpEncapsulation]

