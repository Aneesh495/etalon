implementation module Etalon.Tests.TestAmplifiers

/*
 * TestAmplifiers.icl: EDFA amplifier gain, saturation, and ASE noise calculation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestAmplifiers
import Etalon.Physical.Amplifier


testEdfaGainAndAse :: TestCaseResult
testEdfaGainAndAse =
    let edfa = createStandardEdfa 1 20.0 5.0 20.0
        aseW = computeAsePowerW edfa 50.0e9
        aseDbm = powerWattsToDbm aseW
        a1 = assertRealNear "Gain is 20 dB" 20.0 edfa.targetGainDb 0.01
        a2 = assertRealNear "Noise figure is 5 dB" 5.0 edfa.noiseFigureDb 0.01
        a3 = assertBool "ASE power is physical (> -50 dBm)" True (aseDbm > ~50.0)
    in makeCaseResult "testEdfaGainAndAse" [a1, a2, a3] 0.5


runSuiteTestAmplifiers :: TestSuiteResult
runSuiteTestAmplifiers =
    makeSuiteResult "TestAmplifiers" [testEdfaGainAndAse]
