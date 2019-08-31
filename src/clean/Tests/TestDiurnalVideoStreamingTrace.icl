implementation module Etalon.Tests.TestDiurnalVideoStreamingTrace

/*
 * TestDiurnalVideoStreamingTrace.icl: Streaming demands verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDiurnalVideoStreamingTrace
import Etalon.Simulation.DiurnalVideoStreamingTrace


testStreaming :: TestCaseResult
testStreaming =
    let dem = generateStreamingDemands 25 20.0 // 20:00 prime time
        a1 = assertIntEq "Generated 25 streaming demands" 25 (length dem)
    in makeCaseResult "testStreaming" [a1] 0.4

runSuiteTestDiurnalVideoStreamingTrace :: TestSuiteResult
runSuiteTestDiurnalVideoStreamingTrace = makeSuiteResult "TestDiurnalVideoStreamingTrace" [testStreaming]

