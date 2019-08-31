implementation module Etalon.Tests.TestLatencyModel

/*
 * TestLatencyModel.icl: Detailed end-to-end latency budget breakdown test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestLatencyModel
import Etalon.Topology.LatencyModel


testDetailedLatencyBreakdown :: TestCaseResult
testDetailedLatencyBreakdown =
    let route = createOpticalRoute 1 1 2 [1, 2] 1000.0 17000.0 5.0
        breakdown = computeDetailedLatency route 5 3.0
        a1 = assertRealNear "Fiber delay is 4900 us for 1000km" 4900.0 breakdown.fiberPropagationDelayUs 1.0
        a2 = assertBool "Total delay > fiber delay" True (breakdown.totalEndToEndDelayUs > breakdown.fiberPropagationDelayUs)
    in makeCaseResult "testDetailedLatencyBreakdown" [a1, a2] 0.5

runSuiteTestLatencyModel :: TestSuiteResult
runSuiteTestLatencyModel = makeSuiteResult "TestLatencyModel" [testDetailedLatencyBreakdown]

