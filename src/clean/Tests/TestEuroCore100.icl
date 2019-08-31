implementation module Etalon.Tests.TestEuroCore100

/*
 * TestEuroCore100.icl: EuroCore100 verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestEuroCore100
import Etalon.Topologies.EuroCore100


testEuro100 :: TestCaseResult
testEuro100 =
    let g = buildEuroCore100
        a1 = assertIntEq "EuroCore100 has 100 nodes" 100 g.nodeCount
        a2 = assertIntEq "EuroCore100 has 240 links" 240 g.linkCount
    in makeCaseResult "testEuro100" [a1, a2] 0.5

runSuiteTestEuroCore100 :: TestSuiteResult
runSuiteTestEuroCore100 = makeSuiteResult "TestEuroCore100" [testEuro100]

