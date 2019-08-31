implementation module Etalon.Tests.TestSlaManager

/*
 * TestSlaManager.icl: SLA availability accounting test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSlaManager
import Etalon.Simulation.SlaManager


testSlaCompliance :: TestCaseResult
testSlaCompliance =
    let recCompliant = { serviceId = 1, targetAvailabilityPercent = 99.99, totalUptimeSeconds = 31536000.0, totalDowntimeSeconds = 300.0 }
        recNonCompliant = { serviceId = 2, targetAvailabilityPercent = 99.999, totalUptimeSeconds = 31536000.0, totalDowntimeSeconds = 3600.0 }
        a1 = assertBool "First record meets 99.99% SLA" True (isSlaCompliant recCompliant)
        a2 = assertBool "Second record violates 99.999% SLA (1h down)" False (isSlaCompliant recNonCompliant)
    in makeCaseResult "testSlaCompliance" [a1, a2] 0.4

runSuiteTestSlaManager :: TestSuiteResult
runSuiteTestSlaManager = makeSuiteResult "TestSlaManager" [testSlaCompliance]

