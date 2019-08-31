implementation module Etalon.Tests.TestTrafficGenerator

/*
 * TestTrafficGenerator.icl: Poisson arrival and exponential holding time traffic generation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTrafficGenerator
import Etalon.Simulation.TrafficGenerator


testPoissonTraffic :: TestCaseResult
testPoissonTraffic =
    let gen = createTrafficGenerator 10.0 100.0 [1, 2, 3, 4] 12345
        (dem, nextGen) = generateNextDemand gen 0.0
        a1 = assertBool "Demand bitrate is positive" True (dem.requestedBitrateGbps > 0.0)
        a2 = assertBool "Ingress and egress are distinct" True (dem.ingressNodeId <> dem.egressNodeId)
    in makeCaseResult "testPoissonTraffic" [a1, a2] 0.5


runSuiteTestTrafficGenerator :: TestSuiteResult
runSuiteTestTrafficGenerator =
    makeSuiteResult "TestTrafficGenerator" [testPoissonTraffic]
