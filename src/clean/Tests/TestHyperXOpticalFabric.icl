implementation module Etalon.Tests.TestHyperXOpticalFabric

/*
 * TestHyperXOpticalFabric.icl: HyperX fabric verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestHyperXOpticalFabric
import Etalon.Topologies.HyperXOpticalFabric


testHyperX :: TestCaseResult
testHyperX =
    let g = buildHyperXFabric
        a1 = assertIntEq "HyperX has 36 nodes" 36 g.nodeCount
    in makeCaseResult "testHyperX" [a1] 0.4

runSuiteTestHyperXOpticalFabric :: TestSuiteResult
runSuiteTestHyperXOpticalFabric = makeSuiteResult "TestHyperXOpticalFabric" [testHyperX]

