implementation module Etalon.Tests.TestSwissCoreMesh

/*
 * TestSwissCoreMesh.icl: Swiss core verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSwissCoreMesh
import Etalon.Topologies.SwissCoreMesh


testSwiss :: TestCaseResult
testSwiss =
    let g = buildSwissCoreMesh
        a1 = assertIntEq "Swiss has 14 nodes" 14 g.nodeCount
        a2 = assertIntEq "Swiss has 20 links" 20 g.linkCount
    in makeCaseResult "testSwiss" [a1, a2] 0.5

runSuiteTestSwissCoreMesh :: TestSuiteResult
runSuiteTestSwissCoreMesh = makeSuiteResult "TestSwissCoreMesh" [testSwiss]

