implementation module Etalon.Tests.TestSncProtectionEngine

/*
 * TestSncProtectionEngine.icl: SNC protection verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSncProtectionEngine
import Etalon.Protection.SncProtectionEngine


testSnc :: TestCaseResult
testSnc =
    let st0 = { protType = SncInherentMonitoring, isWorkingOk = False, isProtectOk = True, activeIsWorking = True }
        st1 = evaluateSncSwitch st0
        a1 = assertBool "Switches to protection when working fails" False st1.activeIsWorking
    in makeCaseResult "testSnc" [a1] 0.4

runSuiteTestSncProtectionEngine :: TestSuiteResult
runSuiteTestSncProtectionEngine = makeSuiteResult "TestSncProtectionEngine" [testSnc]

