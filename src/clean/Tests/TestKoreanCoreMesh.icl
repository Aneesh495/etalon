implementation module Etalon.Tests.TestKoreanCoreMesh

/*
 * TestKoreanCoreMesh.icl: Korean mesh verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestKoreanCoreMesh
import Etalon.Topologies.KoreanCoreMesh


testKorea :: TestCaseResult
testKorea =
    let g = buildKoreanCoreMesh
        a1 = assertIntEq "Korea has 12 nodes" 12 g.nodeCount
        a2 = assertIntEq "Korea has 18 links" 18 g.linkCount
    in makeCaseResult "testKorea" [a1, a2] 0.5

runSuiteTestKoreanCoreMesh :: TestSuiteResult
runSuiteTestKoreanCoreMesh = makeSuiteResult "TestKoreanCoreMesh" [testKorea]

