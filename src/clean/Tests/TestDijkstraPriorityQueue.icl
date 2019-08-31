implementation module Etalon.Tests.TestDijkstraPriorityQueue

/*
 * TestDijkstraPriorityQueue.icl: Dijkstra priority queue verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDijkstraPriorityQueue
import Etalon.Algorithms.DijkstraPriorityQueue


testDijkstra :: TestCaseResult
testDijkstra =
    let path = computeDijkstraShortestPath 4 1 4 [(1, 2, 10.0), (2, 4, 15.0), (1, 4, 50.0)]
        a1 = assertIntEq "Path starts with node 1" 1 path.[0]
    in makeCaseResult "testDijkstra" [a1] 0.4

runSuiteTestDijkstraPriorityQueue :: TestSuiteResult
runSuiteTestDijkstraPriorityQueue = makeSuiteResult "TestDijkstraPriorityQueue" [testDijkstra]

