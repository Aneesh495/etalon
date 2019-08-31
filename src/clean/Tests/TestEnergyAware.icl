implementation module Etalon.Tests.TestEnergyAware

/*
 * TestEnergyAware.icl: Green optical power evaluation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestEnergyAware
import Etalon.Routing.EnergyAwareRouting


testEnergyEvaluation :: TestCaseResult
testEnergyEvaluation =
    let g = createEmptyOpticalGraph
        ws = initWorldState g
        watts = computeTotalNetworkPowerWatts ws
        a1 = assertBool "Network power is non-negative" True (watts >= 0.0)
        savings = evaluatePowerSavingsRatio 10000.0 7500.0
        a2 = assertRealNear "Power savings is 25%" 0.25 savings 0.01
    in makeCaseResult "testEnergyEvaluation" [a1, a2] 0.4

runSuiteTestEnergyAware :: TestSuiteResult
runSuiteTestEnergyAware = makeSuiteResult "TestEnergyAware" [testEnergyEvaluation]

