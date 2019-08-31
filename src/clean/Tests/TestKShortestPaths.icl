implementation module Etalon.Tests.TestKShortestPaths

/*
 * TestKShortestPaths.icl: Yen's K-shortest loopless optical paths calculation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestKShortestPaths
import Etalon.Routing.KShortestPaths
import Etalon.Topology.Graph
import Etalon.Physical.Fiber


testYenKShortestPaths :: TestCaseResult
testYenKShortestPaths =
    let g0 = createEmptyOpticalGraph
        n1 = createCdcRoadmNode 1 "A" 2 8
        n2 = createCdcRoadmNode 2 "B" 2 8
        n3 = createCdcRoadmNode 3 "C" 2 8
        g1 = addNodeToGraph (addNodeToGraph (addNodeToGraph g0 n1) n2) n3
        l1 = createOpticalLink 1 1 2 50.0 []
        l2 = createOpticalLink 2 2 3 50.0 []
        l3 = createOpticalLink 3 1 3 150.0 []
        g2 = addLinkToGraph (addLinkToGraph (addLinkToGraph g1 l1) l2) l3
        paths = findKShortestPaths g2 1 3 2
        a1 = assertIntEq "Found 2 shortest paths" 2 (length paths)
        p1 = paths.[0]
        a2 = assertRealNear "Shortest path is 100km (via B)" 100.0 p1.totalLengthKm 0.1
    in makeCaseResult "testYenKShortestPaths" [a1, a2] 0.6


runSuiteTestKShortestPaths :: TestSuiteResult
runSuiteTestKShortestPaths =
    makeSuiteResult "TestKShortestPaths" [testYenKShortestPaths]
