implementation module Etalon.Tests.TestEdfaControllerRegisters

/*
 * TestEdfaControllerRegisters.icl: EDFA controller registers verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestEdfaControllerRegisters
import Etalon.Hardware.EdfaControllerRegisters


testEdfaRegisters :: TestCaseResult
testEdfaRegisters =
    let ok = setEdfaMode 1 (ModeConstantGain 20.0)
        a1 = assertBool "Set EDFA gain succeeds" True ok
    in makeCaseResult "testEdfaRegisters" [a1] 0.4

runSuiteTestEdfaControllerRegisters :: TestSuiteResult
runSuiteTestEdfaControllerRegisters = makeSuiteResult "TestEdfaControllerRegisters" [testEdfaRegisters]

