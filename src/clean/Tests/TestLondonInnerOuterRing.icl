implementation module Etalon.Tests.TestLondonInnerOuterRing

/*
 * TestLondonInnerOuterRing.icl: London metro verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestLondonInnerOuterRing
import Etalon.Topologies.LondonInnerOuterRing


testLondon :: TestCaseResult
testLondon =
    let g = buildLondonInnerOuterRing
        a1 = assertIntEq "London has 18 nodes" 18 g.nodeCount
        a2 = assertIntEq "London has 36 links" 36 g.linkCount
    in makeCaseResult "testLondon" [a1, a2] 0.4

runSuiteTestLondonInnerOuterRing :: TestSuiteResult
runSuiteTestLondonInnerOuterRing = makeSuiteResult "TestLondonInnerOuterRing" [testLondon]

