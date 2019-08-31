implementation module Etalon.Tests.TestLaserDriverRegisters

/*
 * TestLaserDriverRegisters.icl: Laser driver registers verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestLaserDriverRegisters
import Etalon.Hardware.LaserDriverRegisters


testLaserDriverReg :: TestCaseResult
testLaserDriverReg =
    let pid = { kp = 1.0, ki = 0.1, kd = 0.05 }
        ok = configureLaserTec 1 pid 25.0
        a1 = assertBool "Configure TEC succeeds" True ok
    in makeCaseResult "testLaserDriverReg" [a1] 0.4

runSuiteTestLaserDriverRegisters :: TestSuiteResult
runSuiteTestLaserDriverRegisters = makeSuiteResult "TestLaserDriverRegisters" [testLaserDriverReg]

