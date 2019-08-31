implementation module Etalon.Tests.TestRamanGainProfile

/*
 * TestRamanGainProfile.icl: Distributed Raman gain and counter-propagating pump depletion test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestRamanGainProfile
import Etalon.Physical.RamanAmplifier
import Etalon.Physical.Fiber


testRamanAmplification :: TestCaseResult
testRamanAmplification =
    let span = createFiberSpan 1 80.0 standardSmf28
        pump = defaultRamanPump
        prof = computeRamanGainProfile span [pump] 0.001
        a1 = assertBool "Raman provides positive on-off gain (> 5 dB)" True (prof.onOffGainDb > 5.0)
        a2 = assertBool "Effective NF is negative (carrier-grade benefit)" True (prof.effectiveNoiseFigureDb < 0.0)
    in makeCaseResult "testRamanAmplification" [a1, a2] 0.5


runSuiteTestRamanGainProfile :: TestSuiteResult
runSuiteTestRamanGainProfile =
    makeSuiteResult "TestRamanGainProfile" [testRamanAmplification]
