implementation module Etalon.Tests.TestPhotonicIntegratedCircuit

/*
 * TestPhotonicIntegratedCircuit.icl: PIC chip verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPhotonicIntegratedCircuit
import Etalon.Models.PhotonicIntegratedCircuit


testPic :: TestCaseResult
testPic =
    let chip = defaultSiliconPic
        a1 = assertRealNear "V_pi is 1.8 V" 1.8 chip.modulatorVPi 0.01
    in makeCaseResult "testPic" [a1] 0.4

runSuiteTestPhotonicIntegratedCircuit :: TestSuiteResult
runSuiteTestPhotonicIntegratedCircuit = makeSuiteResult "TestPhotonicIntegratedCircuit" [testPic]

