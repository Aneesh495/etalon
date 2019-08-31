implementation module Etalon.Tests.TestEdfaDualStageModel

/*
 * TestEdfaDualStageModel.icl: Dual-stage EDFA verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestEdfaDualStageModel
import Etalon.Models.EdfaDualStageModel


testDualStageEdfa :: TestCaseResult
testDualStageEdfa =
    let edfa = { stage1GainDb = 15.0, stage2GainDb = 15.0, midStageLossDb = 6.0, stage1NoiseFigDb = 4.5, stage2NoiseFigDb = 5.5 }
        totGain = computeTotalGainDb edfa
        compNf = computeCompositeNfDb edfa
        a1 = assertRealNear "Total gain is 24 dB" 24.0 totGain 0.01
        a2 = assertBool "Composite NF is physical (> 4.5 dB)" True (compNf > 4.5)
    in makeCaseResult "testDualStageEdfa" [a1, a2] 0.5

runSuiteTestEdfaDualStageModel :: TestSuiteResult
runSuiteTestEdfaDualStageModel = makeSuiteResult "TestEdfaDualStageModel" [testDualStageEdfa]

