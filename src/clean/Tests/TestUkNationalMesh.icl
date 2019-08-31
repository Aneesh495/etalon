implementation module Etalon.Tests.TestUkNationalMesh

/*
 * TestUkNationalMesh.icl: UK mesh verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestUkNationalMesh
import Etalon.Topologies.UkNationalMesh


testUkMesh :: TestCaseResult
testUkMesh =
    let g = buildUkNationalMesh
        a1 = assertIntEq "UK has 22 nodes" 22 g.nodeCount
        a2 = assertIntEq "UK has 32 links" 32 g.linkCount
    in makeCaseResult "testUkMesh" [a1, a2] 0.5

runSuiteTestUkNationalMesh :: TestSuiteResult
runSuiteTestUkNationalMesh = makeSuiteResult "TestUkNationalMesh" [testUkMesh]

