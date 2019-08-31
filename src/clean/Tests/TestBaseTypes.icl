implementation module Etalon.Tests.TestBaseTypes

/*
 * TestBaseTypes.icl: Comprehensive verification of fundamental optical constants and conversions test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestBaseTypes
import Etalon.Types.Base


testFrequencyWavelengthConversion :: TestCaseResult
testFrequencyWavelengthConversion =
    let freq = 193.1e12 // 193.1 THz (standard C-band reference)
        wl = freqHzToWavelengthM freq
        reconverted = wavelengthMToFreqHz wl
        a1 = assertRealNear "Wavelength of 193.1 THz near 1552.52 nm" 1.552524e-6 wl 1.0e-9
        a2 = assertRealNear "Reconverted frequency equals original" freq reconverted 1.0e6
        a3 = assertRealNear "Speed of light is 299792458 m/s" 299792458.0 speedOfLight 0.1
    in makeCaseResult "testFrequencyWavelengthConversion" [a1, a2, a3] 0.5

testPowerDecibelConversions :: TestCaseResult
testPowerDecibelConversions =
    let pWatts = 0.001 // 1 mW = 0 dBm
        pDbm = powerWattsToDbm pWatts
        reconvertedW = powerDbmToWatts pDbm
        a1 = assertRealNear "1 mW is 0 dBm" 0.0 pDbm 0.001
        a2 = assertRealNear "0 dBm reconverted is 1 mW" 0.001 reconvertedW 1.0e-6
        a3 = assertRealNear "10 mW is 10 dBm" 10.0 (powerWattsToDbm 0.010) 0.001
        a4 = assertRealNear "-30 dBm is 1 uW" 1.0e-6 (powerDbmToWatts ~30.0) 1.0e-8
    in makeCaseResult "testPowerDecibelConversions" [a1, a2, a3, a4] 0.6


runSuiteTestBaseTypes :: TestSuiteResult
runSuiteTestBaseTypes =
    makeSuiteResult "TestBaseTypes" [testFrequencyWavelengthConversion, testPowerDecibelConversions]
