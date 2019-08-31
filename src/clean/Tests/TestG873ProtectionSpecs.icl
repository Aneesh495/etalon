implementation module Etalon.Tests.TestG873ProtectionSpecs

/*
 * TestG873ProtectionSpecs.icl: G.873 protection specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG873ProtectionSpecs
import Etalon.Standards.G873ProtectionSpecs


testG873 :: TestCaseResult
testG873 =
    let wtr = getWaitToRestoreTimerSec
        a1 = assertIntEq "WTR timer is 300s" 300 wtr
    in makeCaseResult "testG873" [a1] 0.4

runSuiteTestG873ProtectionSpecs :: TestSuiteResult
runSuiteTestG873ProtectionSpecs = makeSuiteResult "TestG873ProtectionSpecs" [testG873]

