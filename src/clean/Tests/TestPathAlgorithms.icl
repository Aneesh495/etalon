implementation module Etalon.Tests.TestPathAlgorithms

/*
 * TestPathAlgorithms.icl: Optical route metrics, accumulated dispersion, and latency test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPathAlgorithms
import Etalon.Topology.Path


testRouteMetrics :: TestCaseResult
testRouteMetrics =
    let r = createOpticalRoute 1 1 3 [1, 2] 250.0 4250.0 1.25
        a1 = assertIntEq "Hop count is 2" 2 (getHopCount r)
        a2 = assertRealNear "Total length is 250 km" 250.0 r.totalLengthKm 0.01
        a3 = assertRealNear "Propagation delay is 1.25 ms" 1.25 r.propagationDelayMs 0.01
    in makeCaseResult "testRouteMetrics" [a1, a2, a3] 0.4


runSuiteTestPathAlgorithms :: TestSuiteResult
runSuiteTestPathAlgorithms =
    makeSuiteResult "TestPathAlgorithms" [testRouteMetrics]
