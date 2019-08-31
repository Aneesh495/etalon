implementation module Etalon.Tests.TestDualFailure

/*
 * TestDualFailure.icl: Dual fiber cut survivability test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDualFailure
import Etalon.Protection.DualFailureSurvivability


testDualCutSurvivabilityMetric :: TestCaseResult
testDualCutSurvivabilityMetric =
    let g = buildUsNet
        surv = computeDualCutSurvivability g
        a1 = assertBool "US-Net dual cut survivability > 90%" True (surv > 0.90)
    in makeCaseResult "testDualCutSurvivabilityMetric" [a1] 0.4

runSuiteTestDualFailure :: TestSuiteResult
runSuiteTestDualFailure = makeSuiteResult "TestDualFailure" [testDualCutSurvivabilityMetric]

