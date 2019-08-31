implementation module Etalon.Tests.TestBellmanFordResidual

/*
 * TestBellmanFordResidual.icl: Bellman-Ford verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestBellmanFordResidual
import Etalon.Algorithms.BellmanFordResidual


testBellmanFord :: TestCaseResult
testBellmanFord =
    let hasNeg = hasNegativeCycle 4 [(1, 2, 10.0), (2, 3, 20.0)]
        a1 = assertBool "No negative cycles in positive optical graph" False hasNeg
    in makeCaseResult "testBellmanFord" [a1] 0.4

runSuiteTestBellmanFordResidual :: TestSuiteResult
runSuiteTestBellmanFordResidual = makeSuiteResult "TestBellmanFordResidual" [testBellmanFord]

