implementation module Etalon.Tests.TestAnycastRouting

/*
 * TestAnycastRouting.icl: Edge datacenter replica selection test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestAnycastRouting
import Etalon.Routing.AnycastRouting


testAnycastSelection :: TestCaseResult
testAnycastSelection =
    let dc1 = { dcNodeId = 1, availableComputeGflops = 1000.0, opticalDistanceKm = 100.0 }
        dc2 = { dcNodeId = 2, availableComputeGflops = 5000.0, opticalDistanceKm = 200.0 }
        (?Just best) = selectOptimalDataCenter [dc1, dc2]
        a1 = assertIntEq "DC 2 selected due to higher compute-to-distance score" 2 best.dcNodeId
    in makeCaseResult "testAnycastSelection" [a1] 0.4

runSuiteTestAnycastRouting :: TestSuiteResult
runSuiteTestAnycastRouting = makeSuiteResult "TestAnycastRouting" [testAnycastSelection]

