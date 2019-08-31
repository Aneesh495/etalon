implementation module Etalon.Tests.TestThresholdCrossingAlerts

/*
 * TestThresholdCrossingAlerts.icl: TCA alert verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestThresholdCrossingAlerts
import Etalon.Monitoring.ThresholdCrossingAlerts


testTca :: TestCaseResult
testTca =
    let alert = checkTcaAlert 100 50
        a1 = assertBool "Alert triggered when exceeding threshold" True alert
    in makeCaseResult "testTca" [a1] 0.4

runSuiteTestThresholdCrossingAlerts :: TestSuiteResult
runSuiteTestThresholdCrossingAlerts = makeSuiteResult "TestThresholdCrossingAlerts" [testTca]

