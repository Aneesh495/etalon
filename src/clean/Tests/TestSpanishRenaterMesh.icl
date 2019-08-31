implementation module Etalon.Tests.TestSpanishRenaterMesh

/*
 * TestSpanishRenaterMesh.icl: Spain mesh verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSpanishRenaterMesh
import Etalon.Topologies.SpanishRenaterMesh


testSpain :: TestCaseResult
testSpain =
    let g = buildSpanishRenaterMesh
        a1 = assertIntEq "Spain has 22 nodes" 22 g.nodeCount
        a2 = assertIntEq "Spain has 32 links" 32 g.linkCount
    in makeCaseResult "testSpain" [a1, a2] 0.5

runSuiteTestSpanishRenaterMesh :: TestSuiteResult
runSuiteTestSpanishRenaterMesh = makeSuiteResult "TestSpanishRenaterMesh" [testSpain]

