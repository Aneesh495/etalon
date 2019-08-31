implementation module Etalon.Tests.TestOpticalSwitchRegisters

/*
 * TestOpticalSwitchRegisters.icl: Optical switch registers verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpticalSwitchRegisters
import Etalon.Hardware.OpticalSwitchRegisters


testOptSwitchReg :: TestCaseResult
testOptSwitchReg =
    let ok = latchOpticalSwitch 1 SwitchBar
        a1 = assertBool "Latch switch succeeds" True ok
    in makeCaseResult "testOptSwitchReg" [a1] 0.4

runSuiteTestOpticalSwitchRegisters :: TestSuiteResult
runSuiteTestOpticalSwitchRegisters = makeSuiteResult "TestOpticalSwitchRegisters" [testOptSwitchReg]

