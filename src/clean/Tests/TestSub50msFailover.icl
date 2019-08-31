implementation module Etalon.Tests.TestSub50msFailover

/*
 * TestSub50msFailover.icl: Carrier-grade sub-50ms fault detection, signaling, and cross-connect latch test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSub50msFailover
import Etalon.Protection.FaultManager
import Etalon.Topology.NetworkState
import Etalon.Topology.Graph


testSub50msBudget :: TestCaseResult
testSub50msBudget =
    let fm0 = createFaultManager
        g = createEmptyOpticalGraph
        ws = initWorldState g
        (fm1, ws1, result) = handleFiberCut fm0 ws 101 0.0
        a1 = assertBool "Failover achieved under 50ms standard" True (result.switchoverTimeMs < 50.0)
        a2 = assertRealNear "Detection time near 5ms" 5.0 result.faultDetectionTimeMs 1.0
        a3 = assertRealNear "WSS latch time near 20ms" 20.0 result.hardwareSwitchTimeMs 2.0
    in makeCaseResult "testSub50msBudget" [a1, a2, a3] 0.6


runSuiteTestSub50msFailover :: TestSuiteResult
runSuiteTestSub50msFailover =
    makeSuiteResult "TestSub50msFailover" [testSub50msBudget]
