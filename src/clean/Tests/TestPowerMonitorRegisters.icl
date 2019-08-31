implementation module Etalon.Tests.TestPowerMonitorRegisters

/*
 * TestPowerMonitorRegisters.icl: OPM power monitor registers verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPowerMonitorRegisters
import Etalon.Hardware.PowerMonitorRegisters


testOpmReg :: TestCaseResult
testOpmReg =
    let pwr = readOpmChannelPowerDbm 1 10
        a1 = assertRealNear "OPM reads -12.5 dBm" (~12.5) pwr 0.01
    in makeCaseResult "testOpmReg" [a1] 0.4

runSuiteTestPowerMonitorRegisters :: TestSuiteResult
runSuiteTestPowerMonitorRegisters = makeSuiteResult "TestPowerMonitorRegisters" [testOpmReg]

