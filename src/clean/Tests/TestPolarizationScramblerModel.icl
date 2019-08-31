implementation module Etalon.Tests.TestPolarizationScramblerModel

/*
 * TestPolarizationScramblerModel.icl: Polarization scrambler verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPolarizationScramblerModel
import Etalon.Models.PolarizationScramblerModel


testScrambler :: TestCaseResult
testScrambler =
    let s = defaultScrambler
        a1 = assertRealNear "Insertion loss is 2.5 dB" 2.5 s.insertionLossDb 0.01
    in makeCaseResult "testScrambler" [a1] 0.4

runSuiteTestPolarizationScramblerModel :: TestSuiteResult
runSuiteTestPolarizationScramblerModel = makeSuiteResult "TestPolarizationScramblerModel" [testScrambler]

