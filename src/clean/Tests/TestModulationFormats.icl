implementation module Etalon.Tests.TestModulationFormats

/*
 * TestModulationFormats.icl: Coherent optical modulation formats and spectral efficiencies test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestModulationFormats
import Etalon.Types.Modulation


testModulationEfficiencies :: TestCaseResult
testModulationEfficiencies =
    let a1 = assertRealNear "BPSK SE is 1 bit/s/Hz" 1.0 (spectralEfficiency ModBpsk) 0.01
        a2 = assertRealNear "QPSK SE is 2 bit/s/Hz" 2.0 (spectralEfficiency ModQpsk) 0.01
        a3 = assertRealNear "8-QAM SE is 3 bit/s/Hz" 3.0 (spectralEfficiency Mod8Qam) 0.01
        a4 = assertRealNear "16-QAM SE is 4 bit/s/Hz" 4.0 (spectralEfficiency Mod16Qam) 0.01
        a5 = assertRealNear "64-QAM SE is 6 bit/s/Hz" 6.0 (spectralEfficiency Mod64Qam) 0.01
    in makeCaseResult "testModulationEfficiencies" [a1, a2, a3, a4, a5] 0.5

testRequiredSnrThresholds :: TestCaseResult
testRequiredSnrThresholds =
    let a1 = assertRealNear "QPSK requires ~6.5 dB OSNR" 6.5 (requiredOsnrDb ModQpsk) 0.5
        a2 = assertRealNear "16-QAM requires ~14.0 dB OSNR" 14.0 (requiredOsnrDb Mod16Qam) 0.5
        a3 = assertRealNear "64-QAM requires ~21.0 dB OSNR" 21.0 (requiredOsnrDb Mod64Qam) 0.5
    in makeCaseResult "testRequiredSnrThresholds" [a1, a2, a3] 0.4


runSuiteTestModulationFormats :: TestSuiteResult
runSuiteTestModulationFormats =
    makeSuiteResult "TestModulationFormats" [testModulationEfficiencies, testRequiredSnrThresholds]
