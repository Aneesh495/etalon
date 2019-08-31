implementation module Etalon.Tests.TestGermanBackbone

/*
 * TestGermanBackbone.icl: German backbone topology verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGermanBackbone
import Etalon.Topologies.GermanBackbone


testGermanTopology :: TestCaseResult
testGermanTopology =
    let g = buildGermanBackbone
        a1 = assertIntEq "German backbone has 17 nodes" 17 g.nodeCount
        a2 = assertIntEq "German backbone has 26 links" 26 g.linkCount
    in makeCaseResult "testGermanTopology" [a1, a2] 0.5

runSuiteTestGermanBackbone :: TestSuiteResult
runSuiteTestGermanBackbone = makeSuiteResult "TestGermanBackbone" [testGermanTopology]

