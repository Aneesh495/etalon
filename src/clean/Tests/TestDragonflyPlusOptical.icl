implementation module Etalon.Tests.TestDragonflyPlusOptical

/*
 * TestDragonflyPlusOptical.icl: Dragonfly+ fabric verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDragonflyPlusOptical
import Etalon.Topologies.DragonflyPlusOptical


testDragonfly :: TestCaseResult
testDragonfly =
    let g = buildDragonflyPlusFabric
        a1 = assertIntEq "Dragonfly+ has 64 nodes" 64 g.nodeCount
    in makeCaseResult "testDragonfly" [a1] 0.4

runSuiteTestDragonflyPlusOptical :: TestSuiteResult
runSuiteTestDragonflyPlusOptical = makeSuiteResult "TestDragonflyPlusOptical" [testDragonfly]

