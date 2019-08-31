implementation module Etalon.Tests.TestFourFiberBshrRing

/*
 * TestFourFiberBshrRing.icl: BSHR 4-fiber ring verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFourFiberBshrRing
import Etalon.Protection.FourFiberBshrRing


testBshr :: TestCaseResult
testBshr =
    let act1 = evaluateBshrFault 1 True False
        act2 = evaluateBshrFault 1 True True
        a1 = assertBool "Span switch when only working fails" True (case act1 of BshrSpanSwitch 1 -> True; _ -> False)
        a2 = assertBool "Ring switch when both working and protect fail" True (case act2 of BshrRingSwitch 1 -> True; _ -> False)
    in makeCaseResult "testBshr" [a1, a2] 0.4

runSuiteTestFourFiberBshrRing :: TestSuiteResult
runSuiteTestFourFiberBshrRing = makeSuiteResult "TestFourFiberBshrRing" [testBshr]

