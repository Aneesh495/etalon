implementation module Etalon.Tests.TestDedicatedProtection

/*
 * TestDedicatedProtection.icl: 1+1 Dedicated Protection dual-feeding and sub-50ms receiver bridge test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestDedicatedProtection
import Etalon.Protection.DedicatedProtection
import Etalon.Topology.Path


test1Plus1Failover :: TestCaseResult
test1Plus1Failover =
    let pair0 = create1Plus1ProtectionPair 1 101 201 1.0 1.2
        a1 = assertIntEq "Initial active path is Primary" 101 pair0.activeLightpathId
        pair1 = trigger1Plus1Switchover pair0 "LOS_ON_PRIMARY"
        a2 = assertIntEq "Switched active path is Backup" 201 pair1.activeLightpathId
        a3 = assertBool "State is ProtectedActiveBackup" True (case pair1.state of StateProtectedActiveBackup -> True; _ -> False)
    in makeCaseResult "test1Plus1Failover" [a1, a2, a3] 0.5


runSuiteTestDedicatedProtection :: TestSuiteResult
runSuiteTestDedicatedProtection =
    makeSuiteResult "TestDedicatedProtection" [test1Plus1Failover]
