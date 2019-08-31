implementation module Etalon.Tests.TestFifteenMinuteBins

/*
 * TestFifteenMinuteBins.icl: 15-minute PM bin verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFifteenMinuteBins
import Etalon.Monitoring.FifteenMinuteBins


testBins :: TestCaseResult
testBins =
    let bin = createEmptyBin 0
        a1 = assertIntEq "Bin index is 0" 0 bin.binIndex
    in makeCaseResult "testBins" [a1] 0.4

runSuiteTestFifteenMinuteBins :: TestSuiteResult
runSuiteTestFifteenMinuteBins = makeSuiteResult "TestFifteenMinuteBins" [testBins]

