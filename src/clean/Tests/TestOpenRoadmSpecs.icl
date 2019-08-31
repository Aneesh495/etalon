implementation module Etalon.Tests.TestOpenRoadmSpecs

/*
 * TestOpenRoadmSpecs.icl: Open ROADM specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpenRoadmSpecs
import Etalon.Standards.OpenRoadmSpecs


testOpenRoadm :: TestCaseResult
testOpenRoadm =
    let comp = isOpenRoadmCompliant 18.0
        a1 = assertBool "18 dB OSNR is Open ROADM compliant" True comp
    in makeCaseResult "testOpenRoadm" [a1] 0.4

runSuiteTestOpenRoadmSpecs :: TestSuiteResult
runSuiteTestOpenRoadmSpecs = makeSuiteResult "TestOpenRoadmSpecs" [testOpenRoadm]

