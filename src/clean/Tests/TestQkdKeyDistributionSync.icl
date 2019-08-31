implementation module Etalon.Tests.TestQkdKeyDistributionSync

/*
 * TestQkdKeyDistributionSync.icl: QKD session verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestQkdKeyDistributionSync
import Etalon.Security.QkdKeyDistributionSync


testQkd :: TestCaseResult
testQkd =
    let sess = { sessionId = 1, keyRateKbps = 250.0, qberPercent = 3.5 }
        a1 = assertBool "3.5% QBER is secure (< 11%)" True (isQkdSecure sess)
    in makeCaseResult "testQkd" [a1] 0.4

runSuiteTestQkdKeyDistributionSync :: TestSuiteResult
runSuiteTestQkdKeyDistributionSync = makeSuiteResult "TestQkdKeyDistributionSync" [testQkd]

