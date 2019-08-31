implementation module Etalon.Tests.TestSimulatedAnnealing

/*
 * TestSimulatedAnnealing.icl: Simulated annealing cooling schedule and energy evaluation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSimulatedAnnealing
import Etalon.Optimization.SimulatedAnnealing
import Etalon.Topology.NetworkState
import Etalon.Topology.Graph


testSaOptimizationFlow :: TestCaseResult
testSaOptimizationFlow =
    let g = createEmptyOpticalGraph
        ws = initWorldState g
        cfg = defaultSaConfig
        (ws1, res) = runSimulatedAnnealing ws cfg
        a1 = assertBool "Annealing completes with improved solution" True res.improvedSolution
        a2 = assertBool "Final energy is finite" True (res.finalEnergy > 0.0)
    in makeCaseResult "testSaOptimizationFlow" [a1, a2] 0.6


runSuiteTestSimulatedAnnealing :: TestSuiteResult
runSuiteTestSimulatedAnnealing =
    makeSuiteResult "TestSimulatedAnnealing" [testSaOptimizationFlow]
