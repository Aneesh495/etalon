implementation module Etalon.Tests.TestSingaporeDciRing

/*
 * TestSingaporeDciRing.icl: Singapore DCI ring verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSingaporeDciRing
import Etalon.Topologies.SingaporeDciRing


testSingapore :: TestCaseResult
testSingapore =
    let g = buildSingaporeDciRing
        a1 = assertIntEq "Singapore has 10 nodes" 10 g.nodeCount
        a2 = assertIntEq "Singapore has 15 links" 15 g.linkCount
    in makeCaseResult "testSingapore" [a1, a2] 0.5

runSuiteTestSingaporeDciRing :: TestSuiteResult
runSuiteTestSingaporeDciRing = makeSuiteResult "TestSingaporeDciRing" [testSingapore]

