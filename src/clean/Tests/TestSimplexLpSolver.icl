implementation module Etalon.Tests.TestSimplexLpSolver

/*
 * TestSimplexLpSolver.icl: Simplex LP verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSimplexLpSolver
import Etalon.Algorithms.SimplexLpSolver


testSimplex :: TestCaseResult
testSimplex =
    let (ok, optVal, sol) = solvePrimalSimplex [[1.0, 2.0]] [10.0] [5.0, 3.0]
        a1 = assertBool "Simplex finds optimal" True ok
    in makeCaseResult "testSimplex" [a1] 0.4

runSuiteTestSimplexLpSolver :: TestSuiteResult
runSuiteTestSimplexLpSolver = makeSuiteResult "TestSimplexLpSolver" [testSimplex]

