implementation module Etalon.Tests.TestDci

/*
 * TestDci.icl: DCI 800G mesh verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDci
import Etalon.Topologies.DataCenterInterconnect


testDciTopology :: TestCaseResult
testDciTopology =
    let g = buildDciCampusMesh
        a1 = assertIntEq "DCI campus has 4 nodes" 4 g.nodeCount
        a2 = assertIntEq "DCI mesh has 6 links" 6 g.linkCount
    in makeCaseResult "testDciTopology" [a1, a2] 0.4

runSuiteTestDci :: TestSuiteResult
runSuiteTestDci = makeSuiteResult "TestDci" [testDciTopology]

