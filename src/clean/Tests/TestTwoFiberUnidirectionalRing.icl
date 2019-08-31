implementation module Etalon.Tests.TestTwoFiberUnidirectionalRing

/*
 * TestTwoFiberUnidirectionalRing.icl: USHR 2-fiber ring verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTwoFiberUnidirectionalRing
import Etalon.Protection.TwoFiberUnidirectionalRing


testUshr :: TestCaseResult
testUshr =
    let r = createUshrRing 1
        a1 = assertIntEq "Ring ID is 1" 1 r.ringId
    in makeCaseResult "testUshr" [a1] 0.4

runSuiteTestTwoFiberUnidirectionalRing :: TestSuiteResult
runSuiteTestTwoFiberUnidirectionalRing = makeSuiteResult "TestTwoFiberUnidirectionalRing" [testUshr]

