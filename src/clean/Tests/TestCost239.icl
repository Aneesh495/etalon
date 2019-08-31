implementation module Etalon.Tests.TestCost239

/*
 * TestCost239.icl: COST-239 topology verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestCost239
import Etalon.Topologies.Cost239


testCost239Topology :: TestCaseResult
testCost239Topology =
    let g = buildCost239
        a1 = assertIntEq "COST-239 has 11 nodes" 11 g.nodeCount
        a2 = assertIntEq "COST-239 has 26 links" 26 g.linkCount
    in makeCaseResult "testCost239Topology" [a1, a2] 0.5

runSuiteTestCost239 :: TestSuiteResult
runSuiteTestCost239 = makeSuiteResult "TestCost239" [testCost239Topology]

