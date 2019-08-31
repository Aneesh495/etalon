implementation module Etalon.Tests.TestGraspRwaSolver

/*
 * TestGraspRwaSolver.icl: GRASP RWA verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGraspRwaSolver
import Etalon.Optimization.GraspRwaSolver


testGrasp :: TestCaseResult
testGrasp =
    let score = runGraspRwa 100
        a1 = assertRealNear "GRASP returns 950.0" 950.0 score 0.01
    in makeCaseResult "testGrasp" [a1] 0.4

runSuiteTestGraspRwaSolver :: TestSuiteResult
runSuiteTestGraspRwaSolver = makeSuiteResult "TestGraspRwaSolver" [testGrasp]

