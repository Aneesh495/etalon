implementation module Etalon.Tests.TestBenders

/*
 * TestBenders.icl: Benders capacity planning test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestBenders
import Etalon.Optimization.BendersDecomposition


testBendersPlanning :: TestCaseResult
testBendersPlanning =
    let cost = solveMasterIteration 1 []
        a1 = assertBool "Master cost is positive" True (cost > 0.0)
    in makeCaseResult "testBendersPlanning" [a1] 0.4

runSuiteTestBenders :: TestSuiteResult
runSuiteTestBenders = makeSuiteResult "TestBenders" [testBendersPlanning]

