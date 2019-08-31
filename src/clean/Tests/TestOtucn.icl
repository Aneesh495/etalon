implementation module Etalon.Tests.TestOtucn

/*
 * TestOtucn.icl: OTUCn B100G framing test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOtucn
import Etalon.Otn.OtucnFramer


testOtucnFraming :: TestCaseResult
testOtucnFraming =
    let c4 = createOtucnContainer 4
        a1 = assertRealNear "OTUC4 bitrate is ~421 Gbps" 421.032 c4.aggregateBitrateGbps 0.1
    in makeCaseResult "testOtucnFraming" [a1] 0.4

runSuiteTestOtucn :: TestSuiteResult
runSuiteTestOtucn = makeSuiteResult "TestOtucn" [testOtucnFraming]

