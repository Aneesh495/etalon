implementation module Etalon.Tests.TestOpenZRPlusSpecs

/*
 * TestOpenZRPlusSpecs.icl: OpenZR+ specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpenZRPlusSpecs
import Etalon.Standards.OpenZRPlusSpecs


testOpenZr :: TestCaseResult
testOpenZr =
    let reach = getMaxReachKm ZrPlus400G16Qam
        a1 = assertRealNear "400G 16-QAM reach is 1000 km" 1000.0 reach 0.01
    in makeCaseResult "testOpenZr" [a1] 0.4

runSuiteTestOpenZRPlusSpecs :: TestSuiteResult
runSuiteTestOpenZRPlusSpecs = makeSuiteResult "TestOpenZRPlusSpecs" [testOpenZr]

