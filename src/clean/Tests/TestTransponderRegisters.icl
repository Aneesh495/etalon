implementation module Etalon.Tests.TestTransponderRegisters

/*
 * TestTransponderRegisters.icl: CMIS transponder registers verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTransponderRegisters
import Etalon.Hardware.TransponderRegisters


testCmisRegisters :: TestCaseResult
testCmisRegisters =
    let mapReg = readTransponderTelemetry 1
        a1 = assertIntEq "Module state is ready (2)" 2 mapReg.moduleState
        a2 = assertRealNear "Tx power is 0.5 dBm" 0.5 mapReg.txPowerDbm 0.01
    in makeCaseResult "testCmisRegisters" [a1, a2] 0.4

runSuiteTestTransponderRegisters :: TestSuiteResult
runSuiteTestTransponderRegisters = makeSuiteResult "TestTransponderRegisters" [testCmisRegisters]

