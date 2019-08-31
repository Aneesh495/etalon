implementation module Etalon.Tests.TestEthernetPcs

/*
 * TestEthernetPcs.icl: 100GBASE-R 64b/66b PCS framing test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestEthernetPcs
import Etalon.Otn.EthernetPcs


testPcsSyncHeaders :: TestCaseResult
testPcsSyncHeaders =
    let bData = createPcsDataBlock 0x12345678
        bCtrl = createPcsControlBlock 0x9ABCDEF0
        a1 = assertBool "Data block header is SyncDataHeader" True (case bData.header of SyncDataHeader -> True; _ -> False)
        a2 = assertBool "Control block header is SyncControlHeader" True (case bCtrl.header of SyncControlHeader -> True; _ -> False)
    in makeCaseResult "testPcsSyncHeaders" [a1, a2] 0.4

runSuiteTestEthernetPcs :: TestSuiteResult
runSuiteTestEthernetPcs = makeSuiteResult "TestEthernetPcs" [testPcsSyncHeaders]

