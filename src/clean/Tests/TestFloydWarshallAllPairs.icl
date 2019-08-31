implementation module Etalon.Tests.TestFloydWarshallAllPairs

/*
 * TestFloydWarshallAllPairs.icl: Floyd-Warshall verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFloydWarshallAllPairs
import Etalon.Algorithms.FloydWarshallAllPairs


testFloydWarshall :: TestCaseResult
testFloydWarshall =
    let mat = computeAllPairsDistances 3 [(1, 2, 10.0)]
        a1 = assertIntEq "Matrix has 3 rows" 3 (length mat)
    in makeCaseResult "testFloydWarshall" [a1] 0.4

runSuiteTestFloydWarshallAllPairs :: TestSuiteResult
runSuiteTestFloydWarshallAllPairs = makeSuiteResult "TestFloydWarshallAllPairs" [testFloydWarshall]

