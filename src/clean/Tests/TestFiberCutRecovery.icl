implementation module Etalon.Tests.TestFiberCutRecovery

/*
 * TestFiberCutRecovery.icl: Physical fiber cut fault injection and EDFA transient optical surge test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFiberCutRecovery
import Etalon.Simulation.FiberCut


testFiberCutTransientSurge :: TestCaseResult
testFiberCutTransientSurge =
    let cut = createFiberCutScenario 101 10.0 True
        a1 = assertIntEq "Cut link is 101" 101 cut.cutLinkId
        a2 = assertRealNear "EDFA surge power is ~3.5 dB" 3.5 cut.edfaSurgePowerDb 0.1
    in makeCaseResult "testFiberCutTransientSurge" [a1, a2] 0.4


runSuiteTestFiberCutRecovery :: TestSuiteResult
runSuiteTestFiberCutRecovery =
    makeSuiteResult "TestFiberCutRecovery" [testFiberCutTransientSurge]
