implementation module Etalon.Tests.TestBchSuperFec

/*
 * TestBchSuperFec.icl: Super-FEC net coding gain test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestBchSuperFec
import Etalon.Otn.BchSuperFec


testSuperFecGain :: TestCaseResult
testSuperFecGain =
    let cfg = defaultSuperFecConfig
        ncg = computeBchNetCodingGainDb cfg
        a1 = assertRealNear "NCG is 9.35 dB" 9.35 ncg 0.01
    in makeCaseResult "testSuperFecGain" [a1] 0.4

runSuiteTestBchSuperFec :: TestSuiteResult
runSuiteTestBchSuperFec = makeSuiteResult "TestBchSuperFec" [testSuperFecGain]

