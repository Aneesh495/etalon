implementation module Etalon.Tests.TestGaussianNoiseModel

/*
 * TestGaussianNoiseModel.icl: Nonlinear Interference (NLI) power spectral density evaluation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGaussianNoiseModel
import Etalon.Physical.GaussianNoise
import Etalon.Physical.Fiber
import Etalon.Physical.Amplifier


testGnModelComputation :: TestCaseResult
testGnModelComputation =
    let span = createFiberSpan 1 80.0 standardSmf28
        edfa = createStandardEdfa 1 16.0 5.0 20.0
        pwrW = 0.001
        bwHz = 32.0e9
        nliW = computeSpanNliPowerW span pwrW bwHz
        aseW = computeAsePowerW edfa bwHz
        snrDb = computeSpanSnrDb pwrW aseW nliW
        a1 = assertBool "NLI power is positive" True (nliW > 0.0)
        a2 = assertBool "Span SNR is carrier-grade (> 20 dB)" True (snrDb > 20.0)
    in makeCaseResult "testGnModelComputation" [a1, a2] 0.6


runSuiteTestGaussianNoiseModel :: TestSuiteResult
runSuiteTestGaussianNoiseModel =
    makeSuiteResult "TestGaussianNoiseModel" [testGnModelComputation]
