implementation module Etalon.Tests.TestFrankfurtDeCixMesh

/*
 * TestFrankfurtDeCixMesh.icl: Frankfurt DE-CIX verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFrankfurtDeCixMesh
import Etalon.Topologies.FrankfurtDeCixMesh


testFrankfurt :: TestCaseResult
testFrankfurt =
    let g = buildFrankfurtDeCixMesh
        a1 = assertIntEq "Frankfurt has 12 nodes" 12 g.nodeCount
        a2 = assertIntEq "Frankfurt has 24 links" 24 g.linkCount
    in makeCaseResult "testFrankfurt" [a1, a2] 0.4

runSuiteTestFrankfurtDeCixMesh :: TestSuiteResult
runSuiteTestFrankfurtDeCixMesh = makeSuiteResult "TestFrankfurtDeCixMesh" [testFrankfurt]

