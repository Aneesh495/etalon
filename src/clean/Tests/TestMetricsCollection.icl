implementation module Etalon.Tests.TestMetricsCollection

/*
 * TestMetricsCollection.icl: Carrier KPI metrics: blocking probability, utilization, and MTBF test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestMetricsCollection
import Etalon.Simulation.Metrics


testKpiMetricsCalculation :: TestCaseResult
testKpiMetricsCalculation =
    let m0 = createMetricsCollector
        m1 = recordDemandAttempt m0 True 100.0
        m2 = recordDemandAttempt m1 False 100.0
        bp = computeBlockingProbability m2
        a1 = assertRealNear "Blocking probability is 50%" 0.50 bp 0.01
    in makeCaseResult "testKpiMetricsCalculation" [a1] 0.5


runSuiteTestMetricsCollection :: TestSuiteResult
runSuiteTestMetricsCollection =
    makeSuiteResult "TestMetricsCollection" [testKpiMetricsCalculation]
