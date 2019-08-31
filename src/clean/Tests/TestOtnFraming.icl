implementation module Etalon.Tests.TestOtnFraming

/*
 * TestOtnFraming.icl: ITU-T G.709 4x4080 frame geometry and FAS alignment test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOtnFraming
import Etalon.Otn.Frame


testOtnFrameGeometry :: TestCaseResult
testOtnFrameGeometry =
    let f = createOtnFrame Otu4 1
        a1 = assertIntEq "Frame size is 16320 bytes" 16320 otnFrameSizeBytes
        a2 = assertIntEq "Payload size is 15232 bytes" 15232 otnPayloadSizeBytes
        a3 = assertIntEq "FEC size is 1024 bytes" 1024 otnFecSizeBytes
        a4 = assertBool "FAS byte 1 is 0xF6" True (getFrameByte f 1 1 == 0xF6)
        a5 = assertBool "FAS byte 4 is 0x28" True (getFrameByte f 1 4 == 0x28)
    in makeCaseResult "testOtnFrameGeometry" [a1, a2, a3, a4, a5] 0.6


runSuiteTestOtnFraming :: TestSuiteResult
runSuiteTestOtnFraming =
    makeSuiteResult "TestOtnFraming" [testOtnFrameGeometry]
