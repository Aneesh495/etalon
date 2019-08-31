implementation module Etalon.Tests.TestConstellationTables

/*
 * TestConstellationTables.icl: Constellation coordinates verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestConstellationTables
import Etalon.Physical.ConstellationTables


testConstellationPoints :: TestCaseResult
testConstellationPoints =
    let qpsk = getQpskPoints
        qam16 = get16QamPoints
        qam64 = get64QamPoints
        a1 = assertIntEq "QPSK has 4 points" 4 (length qpsk)
        a2 = assertIntEq "16-QAM has 16 points" 16 (length qam16)
        a3 = assertIntEq "64-QAM has 64 points" 64 (length qam64)
    in makeCaseResult "testConstellationPoints" [a1, a2, a3] 0.5

runSuiteTestConstellationTables :: TestSuiteResult
runSuiteTestConstellationTables = makeSuiteResult "TestConstellationTables" [testConstellationPoints]

