implementation module Etalon.Tests.TestSydneyHarborSubseaRing

/*
 * TestSydneyHarborSubseaRing.icl: Sydney ring verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSydneyHarborSubseaRing
import Etalon.Topologies.SydneyHarborSubseaRing


testSydney :: TestCaseResult
testSydney =
    let g = buildSydneyHarborSubseaRing
        a1 = assertIntEq "Sydney has 12 nodes" 12 g.nodeCount
        a2 = assertIntEq "Sydney has 22 links" 22 g.linkCount
    in makeCaseResult "testSydney" [a1, a2] 0.4

runSuiteTestSydneyHarborSubseaRing :: TestSuiteResult
runSuiteTestSydneyHarborSubseaRing = makeSuiteResult "TestSydneyHarborSubseaRing" [testSydney]

