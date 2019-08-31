implementation module Etalon.Tests.TestLargeNeighborhoodSearch

/*
 * TestLargeNeighborhoodSearch.icl: LNS optimization verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestLargeNeighborhoodSearch
import Etalon.Optimization.LargeNeighborhoodSearch


testLns :: TestCaseResult
testLns =
    let score = runLnsOptimization 50
        a1 = assertRealNear "LNS returns 98.5" 98.5 score 0.01
    in makeCaseResult "testLns" [a1] 0.4

runSuiteTestLargeNeighborhoodSearch :: TestSuiteResult
runSuiteTestLargeNeighborhoodSearch = makeSuiteResult "TestLargeNeighborhoodSearch" [testLns]

