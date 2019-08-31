implementation module Etalon.Tests.TestTokyoMetroMeshedRing

/*
 * TestTokyoMetroMeshedRing.icl: Tokyo metro verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTokyoMetroMeshedRing
import Etalon.Topologies.TokyoMetroMeshedRing


testTokyo :: TestCaseResult
testTokyo =
    let g = buildTokyoMetroMeshedRing
        a1 = assertIntEq "Tokyo has 16 nodes" 16 g.nodeCount
        a2 = assertIntEq "Tokyo has 32 links" 32 g.linkCount
    in makeCaseResult "testTokyo" [a1, a2] 0.4

runSuiteTestTokyoMetroMeshedRing :: TestSuiteResult
runSuiteTestTokyoMetroMeshedRing = makeSuiteResult "TestTokyoMetroMeshedRing" [testTokyo]

