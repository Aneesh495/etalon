implementation module Etalon.Tests.TestGradientDescentOptimizer

/*
 * TestGradientDescentOptimizer.icl: Gradient descent verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGradientDescentOptimizer
import Etalon.Algorithms.GradientDescentOptimizer


testGradDescent :: TestCaseResult
testGradDescent =
    let fn x = x * x
        grad x = 2.0 * x
        opt = optimizeGradientDescent fn grad 5.0 0.1 10
        a1 = assertBool "Moves closer to minimum" True (opt < 5.0)
    in makeCaseResult "testGradDescent" [a1] 0.4

runSuiteTestGradientDescentOptimizer :: TestSuiteResult
runSuiteTestGradientDescentOptimizer = makeSuiteResult "TestGradientDescentOptimizer" [testGradDescent]

