implementation module Etalon.Tests.TestParisOpticalCrown

/*
 * TestParisOpticalCrown.icl: Paris metro verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestParisOpticalCrown
import Etalon.Topologies.ParisOpticalCrown


testParis :: TestCaseResult
testParis =
    let g = buildParisOpticalCrown
        a1 = assertIntEq "Paris has 14 nodes" 14 g.nodeCount
        a2 = assertIntEq "Paris has 28 links" 28 g.linkCount
    in makeCaseResult "testParis" [a1, a2] 0.4

runSuiteTestParisOpticalCrown :: TestSuiteResult
runSuiteTestParisOpticalCrown = makeSuiteResult "TestParisOpticalCrown" [testParis]

