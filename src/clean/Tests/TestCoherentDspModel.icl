implementation module Etalon.Tests.TestCoherentDspModel

/*
 * TestCoherentDspModel.icl: Coherent DSP penalty verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestCoherentDspModel
import Etalon.Models.CoherentDspModel


testDspPenalty :: TestCaseResult
testDspPenalty =
    let cfg = { cmaTapsCount = 64, cprBlockSize = 32, frequencyOffsetHz = 50.0e6, residualDispersionPs = 500.0 }
        pen = evaluateDspResidualPenaltyDb cfg
        a1 = assertBool "Residual penalty is small (< 0.5 dB)" True (pen < 0.5)
    in makeCaseResult "testDspPenalty" [a1] 0.4

runSuiteTestCoherentDspModel :: TestSuiteResult
runSuiteTestCoherentDspModel = makeSuiteResult "TestCoherentDspModel" [testDspPenalty]

