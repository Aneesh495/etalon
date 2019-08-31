implementation module Etalon.Tests.TestLaserLinewidthNoise

/*
 * TestLaserLinewidthNoise.icl: Wiener laser phase noise and CPE SNR penalties across modulation orders test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestLaserLinewidthNoise
import Etalon.Physical.LaserPhaseNoise
import Etalon.Types.Modulation


testLaserPhaseDrift :: TestCaseResult
testLaserPhaseDrift =
    let ecl = defaultEclLaser
        cpe = CpeBlindPhaseSearch 32 16
        penQpsk = evaluateLaserPenalty ecl 32.0e9 ModQpsk cpe
        pen16Qam = evaluateLaserPenalty ecl 32.0e9 Mod16Qam cpe
        a1 = assertBool "16-QAM phase penalty exceeds QPSK" True (pen16Qam.effectiveSnrLossDb > penQpsk.effectiveSnrLossDb)
        a2 = assertBool "Cycle slip probability is low" True (penQpsk.cycleSlipProb < 1.0e-4)
    in makeCaseResult "testLaserPhaseDrift" [a1, a2] 0.5


runSuiteTestLaserLinewidthNoise :: TestSuiteResult
runSuiteTestLaserLinewidthNoise =
    makeSuiteResult "TestLaserLinewidthNoise" [testLaserPhaseDrift]
