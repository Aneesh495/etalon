implementation module Etalon.Tests.TestAustraliaBackbone

/*
 * TestAustraliaBackbone.icl: Australia backbone verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestAustraliaBackbone
import Etalon.Topologies.AustraliaBackbone


testAusBackbone :: TestCaseResult
testAusBackbone =
    let g = buildAustraliaBackbone
        a1 = assertIntEq "Australia has 18 nodes" 18 g.nodeCount
        a2 = assertIntEq "Australia has 25 links" 25 g.linkCount
    in makeCaseResult "testAusBackbone" [a1, a2] 0.5

runSuiteTestAustraliaBackbone :: TestSuiteResult
runSuiteTestAustraliaBackbone = makeSuiteResult "TestAustraliaBackbone" [testAusBackbone]

