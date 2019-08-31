implementation module Etalon.Tests.TestHongKongHarborRing

/*
 * TestHongKongHarborRing.icl: Hong Kong ring verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestHongKongHarborRing
import Etalon.Topologies.HongKongHarborRing


testHk :: TestCaseResult
testHk =
    let g = buildHongKongHarborRing
        a1 = assertIntEq "Hong Kong has 10 nodes" 10 g.nodeCount
        a2 = assertIntEq "Hong Kong has 20 links" 20 g.linkCount
    in makeCaseResult "testHk" [a1, a2] 0.4

runSuiteTestHongKongHarborRing :: TestSuiteResult
runSuiteTestHongKongHarborRing = makeSuiteResult "TestHongKongHarborRing" [testHk]

