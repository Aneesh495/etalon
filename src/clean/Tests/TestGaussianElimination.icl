implementation module Etalon.Tests.TestGaussianElimination

/*
 * TestGaussianElimination.icl: Gaussian elimination verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGaussianElimination
import Etalon.Algorithms.GaussianElimination


testGauss :: TestCaseResult
testGauss =
    let sol = solveLinearSystem [[1.0, 0.0], [0.0, 1.0]] [4.0, 8.0]
        a1 = assertRealNear "Solution x0 is 4.0" 4.0 sol.[0] 0.01
        a2 = assertRealNear "Solution x1 is 8.0" 8.0 sol.[1] 0.01
    in makeCaseResult "testGauss" [a1, a2] 0.4

runSuiteTestGaussianElimination :: TestSuiteResult
runSuiteTestGaussianElimination = makeSuiteResult "TestGaussianElimination" [testGauss]

