implementation module Etalon.Tests.TestSpectrumBitmap

/*
 * TestSpectrumBitmap.icl: Flexible grid spectrum bitmap allocation and fragmentation testing test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSpectrumBitmap
import Etalon.Types.Spectrum


testBitmapInitialization :: TestCaseResult
testBitmapInitialization =
    let bm = initSpectrumBitmap totalSlices
        a1 = assertIntEq "Initial free slice count is total slices" totalSlices bm.freeSliceCount
        a2 = assertIntEq "Number of slices is total slices" totalSlices bm.numSlices
    in makeCaseResult "testBitmapInitialization" [a1, a2] 0.4

testBitmapAllocationAndFree :: TestCaseResult
testBitmapAllocationAndFree =
    let bm0 = initSpectrumBitmap totalSlices
        bm1 = allocateSliceRange bm0 10 4
        a1 = assertBool "Slice 10 is occupied" True (isSliceOccupied bm1 10)
        a2 = assertBool "Slice 13 is occupied" True (isSliceOccupied bm1 13)
        a3 = assertBool "Slice 14 is free" False (isSliceOccupied bm1 14)
        a4 = assertIntEq "Free slice count reduced by 4" (totalSlices - 4) bm1.freeSliceCount
        bm2 = freeSliceRange bm1 10 4
        a5 = assertBool "Slice 10 freed" False (isSliceOccupied bm2 10)
        a6 = assertIntEq "Free slice count restored" totalSlices bm2.freeSliceCount
    in makeCaseResult "testBitmapAllocationAndFree" [a1, a2, a3, a4, a5, a6] 0.8


runSuiteTestSpectrumBitmap :: TestSuiteResult
runSuiteTestSpectrumBitmap =
    makeSuiteResult "TestSpectrumBitmap" [testBitmapInitialization, testBitmapAllocationAndFree]
