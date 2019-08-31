implementation module Etalon.Tests.TestGlobalSubseaMesh

/*
 * TestGlobalSubseaMesh.icl: Global subsea verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGlobalSubseaMesh
import Etalon.Topologies.GlobalSubseaMesh


testGlobalSubsea :: TestCaseResult
testGlobalSubsea =
    let g = buildGlobalSubseaMesh
        a1 = assertIntEq "Global subsea has 30 landing stations" 30 g.nodeCount
        a2 = assertIntEq "Global subsea has 48 segments" 48 g.linkCount
    in makeCaseResult "testGlobalSubsea" [a1, a2] 0.5

runSuiteTestGlobalSubseaMesh :: TestSuiteResult
runSuiteTestGlobalSubseaMesh = makeSuiteResult "TestGlobalSubseaMesh" [testGlobalSubsea]

