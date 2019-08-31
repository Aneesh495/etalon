implementation module Etalon.Tests.TestSuurballe

/*
 * TestSuurballe.icl: Suurballe min-cost disjoint pair search test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSuurballe
import Etalon.Protection.SrlgDisjointSuurballe


testSuurballeDisjointPair :: TestCaseResult
testSuurballeDisjointPair =
    let g = createEmptyOpticalGraph
        (r1, r2) = findMinCostDisjointPair g 1 2
        a1 = assertBool "Primary route is non-empty" True (r1.totalLengthKm > 0.0)
        a2 = assertBool "Secondary route is non-empty" True (r2.totalLengthKm > 0.0)
    in makeCaseResult "testSuurballeDisjointPair" [a1, a2] 0.4

runSuiteTestSuurballe :: TestSuiteResult
runSuiteTestSuurballe = makeSuiteResult "TestSuurballe" [testSuurballeDisjointPair]

