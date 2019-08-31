implementation module Etalon.Tests.TestAntColony

/*
 * TestAntColony.icl: Ant colony transition probability test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestAntColony
import Etalon.Optimization.AntColony


testAntColonyPheromone :: TestCaseResult
testAntColonyPheromone =
    let p = computeAcsTransitionProb 1.0 1.0 1.0 2.0
        a1 = assertRealNear "Transition factor is 1.0" 1.0 p 0.01
        tauNew = updatePheromoneTrail 1.0 0.5 0.1
        a2 = assertRealNear "Updated pheromone is 1.4" 1.4 tauNew 0.01
    in makeCaseResult "testAntColonyPheromone" [a1, a2] 0.4

runSuiteTestAntColony :: TestSuiteResult
runSuiteTestAntColony = makeSuiteResult "TestAntColony" [testAntColonyPheromone]

