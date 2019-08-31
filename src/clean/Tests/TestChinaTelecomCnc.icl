implementation module Etalon.Tests.TestChinaTelecomCnc

/*
 * TestChinaTelecomCnc.icl: China backbone verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestChinaTelecomCnc
import Etalon.Topologies.ChinaTelecomCnc


testChinaBackbone :: TestCaseResult
testChinaBackbone =
    let g = buildChinaTelecomCnc
        a1 = assertIntEq "China has 60 nodes" 60 g.nodeCount
        a2 = assertIntEq "China has 90 links" 90 g.linkCount
    in makeCaseResult "testChinaBackbone" [a1, a2] 0.5

runSuiteTestChinaTelecomCnc :: TestSuiteResult
runSuiteTestChinaTelecomCnc = makeSuiteResult "TestChinaTelecomCnc" [testChinaBackbone]

