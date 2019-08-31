implementation module Etalon.Tests.TestApsSignaling

/*
 * TestApsSignaling.icl: ITU-T G.873.1 Automatic Protection Switching 1+1 and 1:1 signaling test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestApsSignaling
import Etalon.Protection.Aps


testApsFrameGeneration :: TestCaseResult
testApsFrameGeneration =
    let frame = buildApsFrame ApsSignalFail False False 1
        a1 = assertBool "APS request is Signal Fail" True (case frame.request of ApsSignalFail -> True; _ -> False)
        a2 = assertIntEq "Revertive mode requested" 1 frame.requestedSignal
    in makeCaseResult "testApsFrameGeneration" [a1, a2] 0.4


runSuiteTestApsSignaling :: TestSuiteResult
runSuiteTestApsSignaling =
    makeSuiteResult "TestApsSignaling" [testApsFrameGeneration]
