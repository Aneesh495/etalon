implementation module Etalon.Tests.TestGmpJustification

/*
 * TestGmpJustification.icl: GMP rate adaptation sigma-delta stuffing test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGmpJustification
import Etalon.Otn.GmpSignalingJustification


testGmpCalculations :: TestCaseResult
testGmpCalculations =
    let prof = computeGmpParameters 10.0 10.709 15232
        a1 = assertBool "Client bytes allocated <= server bytes" True (prof.clientBytesAllocated <= prof.mBytesCount)
        a2 = assertBool "Stuff bytes count is positive" True (prof.stuffBytesCount > 0)
    in makeCaseResult "testGmpCalculations" [a1, a2] 0.4

runSuiteTestGmpJustification :: TestSuiteResult
runSuiteTestGmpJustification = makeSuiteResult "TestGmpJustification" [testGmpCalculations]

