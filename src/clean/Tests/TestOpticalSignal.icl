implementation module Etalon.Tests.TestOpticalSignal

/*
 * TestOpticalSignal.icl: Optical signal channel power and bandwidth verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpticalSignal
import Etalon.Types.OpticalSignal
import Etalon.Types.Spectrum
import Etalon.Types.Modulation


testOpticalChannelCreation :: TestCaseResult
testOpticalChannelCreation =
    let slot = createFrequencySlot 0 4 // 50 GHz slot
        ch = createOpticalChannel 1 slot Mod16Qam FecStandardRS 0.001 32.0e9
        a1 = assertIntEq "Channel ID is 1" 1 ch.channelId
        a2 = assertRealNear "Launch power is 0 dBm" 0.0 (powerWattsToDbm ch.launchPowerW) 0.01
        a3 = assertRealNear "Symbol rate is 32 GBaud" 32.0e9 ch.symbolRateBaud 1.0e6
    in makeCaseResult "testOpticalChannelCreation" [a1, a2, a3] 0.5


runSuiteTestOpticalSignal :: TestSuiteResult
runSuiteTestOpticalSignal =
    makeSuiteResult "TestOpticalSignal" [testOpticalChannelCreation]
