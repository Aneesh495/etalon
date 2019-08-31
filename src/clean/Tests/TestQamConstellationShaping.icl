implementation module Etalon.Tests.TestQamConstellationShaping

/*
 * TestQamConstellationShaping.icl: PCS shaping verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestQamConstellationShaping
import Etalon.Models.QamConstellationShaping


testPcs :: TestCaseResult
testPcs =
    let prob = computeMaxwellBoltzmannProb 1.0 0.1
        a1 = assertBool "Probability is in (0, 1)" True (prob > 0.0 && prob < 1.0)
    in makeCaseResult "testPcs" [a1] 0.4

runSuiteTestQamConstellationShaping :: TestSuiteResult
runSuiteTestQamConstellationShaping = makeSuiteResult "TestQamConstellationShaping" [testPcs]

