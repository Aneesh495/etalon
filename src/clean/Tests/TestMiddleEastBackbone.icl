implementation module Etalon.Tests.TestMiddleEastBackbone

/*
 * TestMiddleEastBackbone.icl: Middle East backbone verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestMiddleEastBackbone
import Etalon.Topologies.MiddleEastBackbone


testMiddleEast :: TestCaseResult
testMiddleEast =
    let g = buildMiddleEastBackbone
        a1 = assertIntEq "Middle East has 16 nodes" 16 g.nodeCount
        a2 = assertIntEq "Middle East has 24 links" 24 g.linkCount
    in makeCaseResult "testMiddleEast" [a1, a2] 0.5

runSuiteTestMiddleEastBackbone :: TestSuiteResult
runSuiteTestMiddleEastBackbone = makeSuiteResult "TestMiddleEastBackbone" [testMiddleEast]

