implementation module Etalon.Tests.TestOpticalTimeDomainReflectometry

/*
 * TestOpticalTimeDomainReflectometry.icl: OTDR verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpticalTimeDomainReflectometry
import Etalon.Diagnostics.OpticalTimeDomainReflectometry


testOtdr :: TestCaseResult
testOtdr =
    let events = detectOtdrEvents [(10.0, 0.2), (25.0, 0.8)]
        a1 = assertIntEq "2 events detected" 2 (length events)
    in makeCaseResult "testOtdr" [a1] 0.4

runSuiteTestOpticalTimeDomainReflectometry :: TestSuiteResult
runSuiteTestOpticalTimeDomainReflectometry = makeSuiteResult "TestOpticalTimeDomainReflectometry" [testOtdr]

