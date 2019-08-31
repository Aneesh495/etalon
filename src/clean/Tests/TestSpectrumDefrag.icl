implementation module Etalon.Tests.TestSpectrumDefrag

/*
 * TestSpectrumDefrag.icl: Shannon entropy spectrum defragmentation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSpectrumDefrag
import Etalon.Routing.SpectrumDefragmentation


testDefragEntropy :: TestCaseResult
testDefragEntropy =
    let bm = initSpectrumBitmap totalSlices
        entropy = computeShannonFragmentationEntropy bm
        a1 = assertBool "Entropy calculation is non-negative" True (entropy >= 0.0)
    in makeCaseResult "testDefragEntropy" [a1] 0.4

runSuiteTestSpectrumDefrag :: TestSuiteResult
runSuiteTestSpectrumDefrag = makeSuiteResult "TestSpectrumDefrag" [testDefragEntropy]

