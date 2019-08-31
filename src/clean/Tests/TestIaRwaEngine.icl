implementation module Etalon.Tests.TestIaRwaEngine

/*
 * TestIaRwaEngine.icl: Impairment-Aware RWA provisioning and OSNR reach validation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestIaRwaEngine
import Etalon.Routing.ImpairmentAware
import Etalon.Topology.NetworkState
import Etalon.Topology.Graph
import Etalon.Types.Base


testIaRwaProvisioning :: TestCaseResult
testIaRwaProvisioning =
    let g = createEmptyOpticalGraph
        ws = initWorldState g
        demand = {
            demandId           = 1,
            ingressNodeId      = 1,
            egressNodeId       = 2,
            requestedBitrateGbps = 100.0,
            requiredOsnrDb     = 14.0,
            maxLatencyMs       = 50.0,
            requiresProtection = False,
            preferredModulation= ?None,
            preferredFec       = FecStandardRS
        }
        reach = checkOpticalReach 20.0 14.0 1000.0 2000.0
        a1 = assertBool "Reach check passes when OSNR > required" True reach.isReachable
    in makeCaseResult "testIaRwaProvisioning" [a1] 0.5


runSuiteTestIaRwaEngine :: TestSuiteResult
runSuiteTestIaRwaEngine =
    makeSuiteResult "TestIaRwaEngine" [testIaRwaProvisioning]
