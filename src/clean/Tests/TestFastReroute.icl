implementation module Etalon.Tests.TestFastReroute

/*
 * TestFastReroute.icl: Optical FRR bypass tunnel test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFastReroute
import Etalon.Protection.FastReroute


testFrrTunnelCreation :: TestCaseResult
testFrrTunnelCreation =
    let route = createOpticalRoute 100 1 2 [3, 4] 150.0 2000.0 0.75
        tunnel = createFrrBypassTunnel 1 1 2 route
        a1 = assertIntEq "Protected link is 1" 1 tunnel.protectedLinkId
        a2 = assertIntEq "PLR node is 1" 1 tunnel.plrNodeId
    in makeCaseResult "testFrrTunnelCreation" [a1, a2] 0.4

runSuiteTestFastReroute :: TestSuiteResult
runSuiteTestFastReroute = makeSuiteResult "TestFastReroute" [testFrrTunnelCreation]

