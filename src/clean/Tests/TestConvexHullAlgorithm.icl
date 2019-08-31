implementation module Etalon.Tests.TestConvexHullAlgorithm

/*
 * TestConvexHullAlgorithm.icl: Convex hull verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestConvexHullAlgorithm
import Etalon.Algorithms.ConvexHullAlgorithm


testHull :: TestCaseResult
testHull =
    let pts = [(0.0, 0.0), (1.0, 0.0), (0.0, 1.0)]
        hull = computeConvexHullPoints pts
        a1 = assertIntEq "3 vertices in triangle hull" 3 (length hull)
    in makeCaseResult "testHull" [a1] 0.4

runSuiteTestConvexHullAlgorithm :: TestSuiteResult
runSuiteTestConvexHullAlgorithm = makeSuiteResult "TestConvexHullAlgorithm" [testHull]

