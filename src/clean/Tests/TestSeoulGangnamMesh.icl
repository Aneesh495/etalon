implementation module Etalon.Tests.TestSeoulGangnamMesh

/*
 * TestSeoulGangnamMesh.icl: Seoul mesh verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSeoulGangnamMesh
import Etalon.Topologies.SeoulGangnamMesh


testSeoul :: TestCaseResult
testSeoul =
    let g = buildSeoulGangnamMesh
        a1 = assertIntEq "Seoul has 14 nodes" 14 g.nodeCount
        a2 = assertIntEq "Seoul has 26 links" 26 g.linkCount
    in makeCaseResult "testSeoul" [a1, a2] 0.4

runSuiteTestSeoulGangnamMesh :: TestSuiteResult
runSuiteTestSeoulGangnamMesh = makeSuiteResult "TestSeoulGangnamMesh" [testSeoul]

