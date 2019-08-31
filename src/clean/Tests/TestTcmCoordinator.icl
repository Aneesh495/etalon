implementation module Etalon.Tests.TestTcmCoordinator

/*
 * TestTcmCoordinator.icl: TCM multi-operator tandem connection monitoring test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTcmCoordinator
import Etalon.Otn.TcmProtectionCoordinator


testTcmLevels :: TestCaseResult
testTcmLevels =
    let c0 = createTcmCoordinator
        c1 = enableTcmLevel c0 2 "CARRIER-TRANSIT-A"
        a1 = assertIntEq "Active levels count is 1" 1 c1.activeLevelCount
        c2 = recordTcmErrors c1 2 15 False
        a2 = assertBool "Defect asserted when BIP errors exceed 8" True (hasTcmDefect c2 2)
    in makeCaseResult "testTcmLevels" [a1, a2] 0.5

runSuiteTestTcmCoordinator :: TestSuiteResult
runSuiteTestTcmCoordinator = makeSuiteResult "TestTcmCoordinator" [testTcmLevels]

