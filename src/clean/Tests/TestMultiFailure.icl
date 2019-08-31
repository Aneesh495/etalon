implementation module Etalon.Tests.TestMultiFailure

/*
 * TestMultiFailure.icl: SLA priority restoration under multi-cut test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestMultiFailure
import Etalon.Protection.MultiFailureResilience


testSlaPrioritization :: TestCaseResult
testMultiFailurePrioritization =
    let s1 = { serviceId = 1, tier = TierBronzeBestEffort, activeLightpathId = 101, isPreempted = False }
        s2 = { serviceId = 2, tier = TierGoldPremium, activeLightpathId = 102, isPreempted = False }
        ordered = prioritizeRestoration [s1, s2]
        first = ordered.[0]
        a1 = assertIntEq "Gold service restored first" 2 first.serviceId
    in makeCaseResult "testMultiFailurePrioritization" [a1] 0.4

runSuiteTestMultiFailure :: TestSuiteResult
runSuiteTestMultiFailure = makeSuiteResult "TestMultiFailure" [testMultiFailurePrioritization]

