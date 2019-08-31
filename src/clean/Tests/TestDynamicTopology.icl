implementation module Etalon.Tests.TestDynamicTopology

/*
 * TestDynamicTopology.icl: Dynamic link weighting and margin health test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDynamicTopology
import Etalon.Topology.DynamicTopology


testDynamicWeighting :: TestCaseResult
testDynamicWeighting =
    let span = createFiberSpan 1 80.0 standardSmf28
        link = createOpticalLink 1 1 2 80.0 [span]
        wHighMargin = computeDynamicLinkWeight link 5.0 0.2
        wLowMargin = computeDynamicLinkWeight link 1.5 0.2
        a1 = assertBool "Low margin link has higher cost weight" True (wLowMargin > wHighMargin)
        a2 = assertBool "5.0 dB margin is healthy" True (evaluateMarginHealth 19.0 14.0)
    in makeCaseResult "testDynamicWeighting" [a1, a2] 0.5

runSuiteTestDynamicTopology :: TestSuiteResult
runSuiteTestDynamicTopology = makeSuiteResult "TestDynamicTopology" [testDynamicWeighting]

