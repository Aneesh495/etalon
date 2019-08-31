implementation module Etalon.Tests.TestVoaRegisters

/*
 * TestVoaRegisters.icl: VOA registers verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestVoaRegisters
import Etalon.Hardware.VoaRegisters


testVoaReg :: TestCaseResult
testVoaReg =
    let ok = setVoaAttenuationDb 1 6.5
        a1 = assertBool "Set VOA attenuation succeeds" True ok
    in makeCaseResult "testVoaReg" [a1] 0.4

runSuiteTestVoaRegisters :: TestSuiteResult
runSuiteTestVoaRegisters = makeSuiteResult "TestVoaRegisters" [testVoaReg]

