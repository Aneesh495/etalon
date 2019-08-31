implementation module Etalon.Tests.TestClient1Plus1Protection

/*
 * TestClient1Plus1Protection.icl: Client 1+1 protection verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestClient1Plus1Protection
import Etalon.Protection.Client1Plus1Protection


testClientProt :: TestCaseResult
testClientProt =
    let p0 = { clientId = 1, primaryPortId = 101, backupPortId = 102, activePortId = 101 }
        p1 = switchClientToBackup p0
        a1 = assertIntEq "Active port is now 102" 102 p1.activePortId
    in makeCaseResult "testClientProt" [a1] 0.4

runSuiteTestClient1Plus1Protection :: TestSuiteResult
runSuiteTestClient1Plus1Protection = makeSuiteResult "TestClient1Plus1Protection" [testClientProt]

