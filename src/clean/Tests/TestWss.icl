implementation module Etalon.Tests.TestWss

/*
 * TestWss.icl: LCoS WSS switching verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestWss
import Etalon.Physical.WavelengthSelectiveSwitch


testWssSwitching :: TestCaseResult
testWssSwitching =
    let wss0 = createWssSwitchMatrix 1 4 4 6
        wss1 = setSliceAttenuation wss0 10 3.5
        att = getSliceAttenuation wss1 10
        a1 = assertRealNear "Slice attenuation is 3.5 dB" 3.5 att 0.01
        flt = { order = 6, bandwidth3DbGhz = 50.0, insertionLossDb = 4.0, centerFreqOffsetGhz = 0.0 }
        t0 = evaluateFilterTransfer flt 0.0
        a2 = assertRealNear "Center transmission is 1.0 (0 dB loss)" 1.0 t0 0.01
    in makeCaseResult "testWssSwitching" [a1, a2] 0.5

runSuiteTestWss :: TestSuiteResult
runSuiteTestWss = makeSuiteResult "TestWss" [testWssSwitching]

