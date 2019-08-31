implementation module Etalon.Tests.TestNordicMesh

/*
 * TestNordicMesh.icl: Nordic mesh verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestNordicMesh
import Etalon.Topologies.NordicMesh


testNordic :: TestCaseResult
testNordic =
    let g = buildNordicMesh
        a1 = assertIntEq "Nordic has 20 nodes" 20 g.nodeCount
        a2 = assertIntEq "Nordic has 30 links" 30 g.linkCount
    in makeCaseResult "testNordic" [a1, a2] 0.5

runSuiteTestNordicMesh :: TestSuiteResult
runSuiteTestNordicMesh = makeSuiteResult "TestNordicMesh" [testNordic]

