implementation module Etalon.Tests.TestInterleaver

/*
 * TestInterleaver.icl: Optical interleaver transmission test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestInterleaver
import Etalon.Physical.Interleaver


testInterleaverTransmission :: TestCaseResult
testInterleaverTransmission =
    let cfg = { channelSpacingGhz = 50.0, passbandRippleDb = 0.2, stopbandRejectionDb = 25.0, insertionLossDb = 3.0 }
        tEven = evaluateMziTransmission cfg 0.0 True
        tOdd = evaluateMziTransmission cfg 0.0 False
        a1 = assertRealNear "Even port transmission at 0 GHz is 1.0" 1.0 tEven 0.01
        a2 = assertRealNear "Odd port transmission at 0 GHz is 0.0" 0.0 tOdd 0.01
    in makeCaseResult "testInterleaverTransmission" [a1, a2] 0.4

runSuiteTestInterleaver :: TestSuiteResult
runSuiteTestInterleaver = makeSuiteResult "TestInterleaver" [testInterleaverTransmission]

