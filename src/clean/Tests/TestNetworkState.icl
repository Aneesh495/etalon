implementation module Etalon.Tests.TestNetworkState

/*
 * TestNetworkState.icl: Global network world state lightpath lifecycle test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestNetworkState
import Etalon.Topology.NetworkState
import Etalon.Topology.Graph


testWorldStateCreation :: TestCaseResult
testWorldStateCreation =
    let g = createEmptyOpticalGraph
        ws = initWorldState g
        a1 = assertIntEq "Active lightpaths initial count is 0" 0 (length ws.activeLightpaths)
        a2 = assertIntEq "Failed links initial count is 0" 0 (length ws.failedLinkIds)
    in makeCaseResult "testWorldStateCreation" [a1, a2] 0.4


runSuiteTestNetworkState :: TestSuiteResult
runSuiteTestNetworkState =
    makeSuiteResult "TestNetworkState" [testWorldStateCreation]
