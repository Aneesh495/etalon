implementation module Etalon.Tests.TestEdfaTransients

/*
 * TestEdfaTransients.icl: EDFA gain excursion test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestEdfaTransients
import Etalon.Physical.EdfaTransientDynamics


testGainExcursion :: TestCaseResult
testGainExcursion =
    let res = evaluateGainExcursion 40 20 10.0 // drop 20 of 40 channels
        a1 = assertBool "Excursion is positive" True (res.peakExcursionDb > 0.0)
        a2 = assertIntEq "20 surviving channels" 20 res.survivingChannelsCount
    in makeCaseResult "testGainExcursion" [a1, a2] 0.4

runSuiteTestEdfaTransients :: TestSuiteResult
runSuiteTestEdfaTransients = makeSuiteResult "TestEdfaTransients" [testGainExcursion]

