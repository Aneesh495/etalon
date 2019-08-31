implementation module Etalon.Tests.TestFastFourierTransform

/*
 * TestFastFourierTransform.icl: Radix-2 FFT verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFastFourierTransform
import Etalon.Algorithms.FastFourierTransform


testFft :: TestCaseResult
testFft =
    let inputs = [(1.0, 0.0), (0.0, 0.0)]
        out = computeRadix2Fft inputs
        a1 = assertIntEq "Output length matches input" 2 (length out)
    in makeCaseResult "testFft" [a1] 0.4

runSuiteTestFastFourierTransform :: TestSuiteResult
runSuiteTestFastFourierTransform = makeSuiteResult "TestFastFourierTransform" [testFft]

