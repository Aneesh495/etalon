implementation module Etalon.Tests.TestItalyGarrMesh

/*
 * TestItalyGarrMesh.icl: Italy GARR verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestItalyGarrMesh
import Etalon.Topologies.ItalyGarrMesh


testItaly :: TestCaseResult
testItaly =
    let g = buildItalyGarrMesh
        a1 = assertIntEq "Italy has 24 nodes" 24 g.nodeCount
        a2 = assertIntEq "Italy has 34 links" 34 g.linkCount
    in makeCaseResult "testItaly" [a1, a2] 0.5

runSuiteTestItalyGarrMesh :: TestSuiteResult
runSuiteTestItalyGarrMesh = makeSuiteResult "TestItalyGarrMesh" [testItaly]

