implementation module Etalon.Tests.TestMonteCarlo

/*
 * TestMonteCarlo.icl: Monte Carlo physical variation simulator test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestMonteCarlo
import Etalon.Simulation.MonteCarloPhysical


testMonteCarloSimulation :: TestCaseResult
testMonteCarloSimulation =
    let trials = runMonteCarloTrials 50 18.0 14.0
        outageRate = computeOutageRate trials
        a1 = assertIntEq "Executed 50 trials" 50 (length trials)
        a2 = assertBool "Outage rate is low for 18 dB OSNR (> 14 dB req)" True (outageRate <= 0.05)
    in makeCaseResult "testMonteCarloSimulation" [a1, a2] 0.5

runSuiteTestMonteCarlo :: TestSuiteResult
runSuiteTestMonteCarlo = makeSuiteResult "TestMonteCarlo" [testMonteCarloSimulation]

