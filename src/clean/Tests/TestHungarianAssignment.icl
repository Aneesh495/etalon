implementation module Etalon.Tests.TestHungarianAssignment

/*
 * TestHungarianAssignment.icl: Hungarian assignment verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestHungarianAssignment
import Etalon.Algorithms.HungarianAssignment


testHungarian :: TestCaseResult
testHungarian =
    let assign = solveOptimalAssignment [[1.0, 2.0], [2.0, 1.0]]
        a1 = assertIntEq "Assigns 2 pairs" 2 (length assign)
    in makeCaseResult "testHungarian" [a1] 0.4

runSuiteTestHungarianAssignment :: TestSuiteResult
runSuiteTestHungarianAssignment = makeSuiteResult "TestHungarianAssignment" [testHungarian]

