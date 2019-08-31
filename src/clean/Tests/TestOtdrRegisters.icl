implementation module Etalon.Tests.TestOtdrRegisters

/*
 * TestOtdrRegisters.icl: OTDR registers verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOtdrRegisters
import Etalon.Hardware.OtdrRegisters


testOtdrReg :: TestCaseResult
testOtdrReg =
    let cfg = { pulseWidthNs = 100, rangeKm = 80.0, averagingTimeSec = 30 }
        ok = triggerOtdrTrace 101 cfg
        a1 = assertBool "OTDR trigger succeeds" True ok
    in makeCaseResult "testOtdrReg" [a1] 0.4

runSuiteTestOtdrRegisters :: TestSuiteResult
runSuiteTestOtdrRegisters = makeSuiteResult "TestOtdrRegisters" [testOtdrReg]

