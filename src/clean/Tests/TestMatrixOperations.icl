implementation module Etalon.Tests.TestMatrixOperations

/*
 * TestMatrixOperations.icl: Matrix multiplication verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestMatrixOperations
import Etalon.Algorithms.MatrixOperations


testMatrixMult :: TestCaseResult
testMatrixMult =
    let m1 = [[1.0, 0.0], [0.0, 1.0]]
        m2 = [[5.0, 2.0], [3.0, 4.0]]
        prod = multiplyMatrices m1 m2
        a1 = assertRealNear "Identity mult preserves element (0,0)" 5.0 (prod.[0].[0]) 0.01
    in makeCaseResult "testMatrixMult" [a1] 0.4

runSuiteTestMatrixOperations :: TestSuiteResult
runSuiteTestMatrixOperations = makeSuiteResult "TestMatrixOperations" [testMatrixMult]

