implementation module Etalon.Tests.TestRungeKutta4Integrator

/*
 * TestRungeKutta4Integrator.icl: Runge-Kutta 4 verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestRungeKutta4Integrator
import Etalon.Algorithms.RungeKutta4Integrator


testRk4 :: TestCaseResult
testRk4 =
    // y' = y => y(1) = e^1 = 2.71828
    let f t y = y
        y1 = integrateRk4Step f 0.0 1.0 0.1
        a1 = assertBool "Step integrates forward" True (y1 > 1.0)
    in makeCaseResult "testRk4" [a1] 0.4

runSuiteTestRungeKutta4Integrator :: TestSuiteResult
runSuiteTestRungeKutta4Integrator = makeSuiteResult "TestRungeKutta4Integrator" [testRk4]

