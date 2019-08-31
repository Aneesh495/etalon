implementation module Etalon.Tests.TestPcepProtocol

/*
 * TestPcepProtocol.icl: PCEP RFC 5440 message encoding and stateful session management test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPcepProtocol
import Etalon.Protocols.Pcep


testPcepSessionHandling :: TestCaseResult
testPcepSessionHandling =
    let sess0 = createPcepSession 1 "10.0.0.1" 30
        req = buildPathRequest 101 1 2 100.0
        sess1 = processIncomingMessage sess0 req
        a1 = assertIntEq "Session ID is 1" 1 sess1.sessionId
        a2 = assertIntEq "Received 1 message" 1 (length sess1.receivedMessages)
    in makeCaseResult "testPcepSessionHandling" [a1, a2] 0.5


runSuiteTestPcepProtocol :: TestSuiteResult
runSuiteTestPcepProtocol =
    makeSuiteResult "TestPcepProtocol" [testPcepSessionHandling]
