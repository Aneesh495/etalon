implementation module Etalon.Tests.TestDailyHistoryBins

/*
 * TestDailyHistoryBins.icl: Daily history bin verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDailyHistoryBins
import Etalon.Monitoring.DailyHistoryBins


testDaily :: TestCaseResult
testDaily =
    let d = createDailyBin 1
        a1 = assertIntEq "Day index is 1" 1 d.dayIndex
    in makeCaseResult "testDaily" [a1] 0.4

runSuiteTestDailyHistoryBins :: TestSuiteResult
runSuiteTestDailyHistoryBins = makeSuiteResult "TestDailyHistoryBins" [testDaily]

