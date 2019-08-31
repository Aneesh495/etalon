implementation module Etalon.Tests.TestRoadmArchitecture

/*
 * TestRoadmArchitecture.icl: ROADM degree insertion loss and CDC add/drop verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestRoadmArchitecture
import Etalon.Physical.Roadm


testRoadmPortLoss :: TestCaseResult
testRoadmPortLoss =
    let roadm = createCdcRoadm 1 4 32
        loss = roadmThroughLossDb roadm
        a1 = assertIntEq "ROADM degree count is 4" 4 roadm.degreeCount
        a2 = assertIntEq "Add/drop capacity is 32" 32 roadm.addDropCapacity
        a3 = assertRealNear "Through loss is ~12 dB" 12.0 loss 1.0
    in makeCaseResult "testRoadmPortLoss" [a1, a2, a3] 0.4


runSuiteTestRoadmArchitecture :: TestSuiteResult
runSuiteTestRoadmArchitecture =
    makeSuiteResult "TestRoadmArchitecture" [testRoadmPortLoss]
