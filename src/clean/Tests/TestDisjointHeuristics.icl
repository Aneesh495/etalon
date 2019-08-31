implementation module Etalon.Tests.TestDisjointHeuristics

/*
 * TestDisjointHeuristics.icl: Bhandari disjoint paths test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDisjointHeuristics
import Etalon.Routing.DisjointPathHeuristics


testBhandariHeuristics :: TestCaseResult
testBhandariHeuristics =
    let g = createEmptyOpticalGraph
        (r1, r2) = findBhandariDisjointPair g 1 2
        a1 = assertBool "Primary route exists" True (r1.totalLengthKm > 0.0)
        a2 = assertBool "Secondary route exists" True (r2.totalLengthKm > 0.0)
    in makeCaseResult "testBhandariHeuristics" [a1, a2] 0.4

runSuiteTestDisjointHeuristics :: TestSuiteResult
runSuiteTestDisjointHeuristics = makeSuiteResult "TestDisjointHeuristics" [testBhandariHeuristics]

