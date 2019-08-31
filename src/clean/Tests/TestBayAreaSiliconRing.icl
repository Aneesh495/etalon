implementation module Etalon.Tests.TestBayAreaSiliconRing

/*
 * TestBayAreaSiliconRing.icl: Bay Area ring verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestBayAreaSiliconRing
import Etalon.Topologies.BayAreaSiliconRing


testBay :: TestCaseResult
testBay =
    let g = buildBayAreaSiliconRing
        a1 = assertIntEq "Bay Area has 16 nodes" 16 g.nodeCount
        a2 = assertIntEq "Bay Area has 30 links" 30 g.linkCount
    in makeCaseResult "testBay" [a1, a2] 0.4

runSuiteTestBayAreaSiliconRing :: TestSuiteResult
runSuiteTestBayAreaSiliconRing = makeSuiteResult "TestBayAreaSiliconRing" [testBay]

