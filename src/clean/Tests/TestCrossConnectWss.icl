implementation module Etalon.Tests.TestCrossConnectWss

/*
 * TestCrossConnectWss.icl: Wavelength selective switch cross-connect switching and verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestCrossConnectWss
import Etalon.Topology.CrossConnect
import Etalon.Types.Spectrum


testCrossConnectSwitching :: TestCaseResult
testCrossConnectSwitching =
    let slot = createFrequencySlot 10 4
        sw0 = createSwitchMatrix 1 4
        (sw1, xc) = provisionCrossConnect sw0 101 1 2 slot
        a1 = assertIntEq "Active cross-connect count is 1" 1 sw1.activeCrossConnectCount
        a2 = assertBool "Cross-connect is active" True xc.isActive
        sw2 = releaseCrossConnect sw1 101
        a3 = assertIntEq "Active cross-connect count is 0 after release" 0 sw2.activeCrossConnectCount
    in makeCaseResult "testCrossConnectSwitching" [a1, a2, a3] 0.6


runSuiteTestCrossConnectWss :: TestSuiteResult
runSuiteTestCrossConnectWss =
    makeSuiteResult "TestCrossConnectWss" [testCrossConnectSwitching]
