implementation module Etalon.Tests.TestGraphTopology

/*
 * TestGraphTopology.icl: Optical graph node adjacency and fiber link insertion test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGraphTopology
import Etalon.Topology.Graph
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm


testGraphConstruction :: TestCaseResult
testGraphConstruction =
    let g0 = createEmptyOpticalGraph
        n1 = createCdcRoadmNode 1 "Node-1" 4 16
        n2 = createCdcRoadmNode 2 "Node-2" 4 16
        g1 = addNodeToGraph g0 n1
        g2 = addNodeToGraph g1 n2
        span = createFiberSpan 101 100.0 standardSmf28
        link = createOpticalLink 1 1 2 100.0 [span]
        g3 = addLinkToGraph g2 link
        a1 = assertIntEq "Graph has 2 nodes" 2 g3.nodeCount
        a2 = assertIntEq "Graph has 1 link" 1 g3.linkCount
        adj = getNodeAdjacencyList g3 1
        a3 = assertIntEq "Node 1 adjacent links count is 1" 1 (length adj)
    in makeCaseResult "testGraphConstruction" [a1, a2, a3] 0.6


runSuiteTestGraphTopology :: TestSuiteResult
runSuiteTestGraphTopology =
    makeSuiteResult "TestGraphTopology" [testGraphConstruction]
