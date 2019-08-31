implementation module Etalon.Tests.TestSpectrumAllocation

/*
 * TestSpectrumAllocation.icl: First-Fit, Best-Fit, and Exact-Fit flexible grid spectrum assignment test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSpectrumAllocation
import Etalon.Routing.SpectrumAssign
import Etalon.Types.Spectrum


testFirstFitAssignment :: TestCaseResult
testFirstFitAssignment =
    let bm0 = initSpectrumBitmap totalSlices
        bm1 = allocateSliceRange bm0 0 10 // occupy slices 0..9
        slotIdx = findFirstFit bm1 8
        a1 = assertIntEq "First-fit allocates starting at slice 10" 10 slotIdx
    in makeCaseResult "testFirstFitAssignment" [a1] 0.4


runSuiteTestSpectrumAllocation :: TestSuiteResult
runSuiteTestSpectrumAllocation =
    makeSuiteResult "TestSpectrumAllocation" [testFirstFitAssignment]
