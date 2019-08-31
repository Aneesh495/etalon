implementation module Etalon.Tests.TestPushRelabelMaxFlow

/*
 * TestPushRelabelMaxFlow.icl: Push-Relabel verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPushRelabelMaxFlow
import Etalon.Algorithms.PushRelabelMaxFlow


testMaxFlow :: TestCaseResult
testMaxFlow =
    let f = computeMaxFlow 4 1 4 [(1, 2, 100.0), (2, 4, 100.0)]
        a1 = assertBool "Flow is positive" True (f > 0.0)
    in makeCaseResult "testMaxFlow" [a1] 0.4

runSuiteTestPushRelabelMaxFlow :: TestSuiteResult
runSuiteTestPushRelabelMaxFlow = makeSuiteResult "TestPushRelabelMaxFlow" [testMaxFlow]

