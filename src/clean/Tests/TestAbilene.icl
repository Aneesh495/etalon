implementation module Etalon.Tests.TestAbilene

/*
 * TestAbilene.icl: Abilene research topology verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestAbilene
import Etalon.Topologies.Abilene


testAbileneTopology :: TestCaseResult
testAbileneTopology =
    let g = buildAbilene
        a1 = assertIntEq "Abilene has 12 nodes" 12 g.nodeCount
        a2 = assertIntEq "Abilene has 15 links" 15 g.linkCount
    in makeCaseResult "testAbileneTopology" [a1, a2] 0.5

runSuiteTestAbilene :: TestSuiteResult
runSuiteTestAbilene = makeSuiteResult "TestAbilene" [testAbileneTopology]

