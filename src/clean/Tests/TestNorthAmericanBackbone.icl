implementation module Etalon.Tests.TestNorthAmericanBackbone

/*
 * TestNorthAmericanBackbone.icl: North American backbone verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestNorthAmericanBackbone
import Etalon.Topologies.NorthAmericanBackbone


testNaBackbone :: TestCaseResult
testNaBackbone =
    let g = buildNaBackbone
        a1 = assertIntEq "NA Backbone has 50 nodes" 50 g.nodeCount
        a2 = assertIntEq "NA Backbone has 112 links" 112 g.linkCount
    in makeCaseResult "testNaBackbone" [a1, a2] 0.5

runSuiteTestNorthAmericanBackbone :: TestSuiteResult
runSuiteTestNorthAmericanBackbone = makeSuiteResult "TestNorthAmericanBackbone" [testNaBackbone]

