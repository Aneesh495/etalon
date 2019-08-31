implementation module Etalon.Tests.TestTorus3DOpticalFabric

/*
 * TestTorus3DOpticalFabric.icl: 3D Torus fabric verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTorus3DOpticalFabric
import Etalon.Topologies.Torus3DOpticalFabric


testTorus :: TestCaseResult
testTorus =
    let g = build3DTorusFabric
        a1 = assertIntEq "3D Torus has 64 nodes" 64 g.nodeCount
    in makeCaseResult "testTorus" [a1] 0.4

runSuiteTestTorus3DOpticalFabric :: TestSuiteResult
runSuiteTestTorus3DOpticalFabric = makeSuiteResult "TestTorus3DOpticalFabric" [testTorus]

