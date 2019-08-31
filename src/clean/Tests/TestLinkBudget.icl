implementation module Etalon.Tests.TestLinkBudget

/*
 * TestLinkBudget.icl: Optical link loss ledger test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestLinkBudget
import Etalon.Topology.OpticalLinkBudget


testSpanLossLedger :: TestCaseResult
testSpanLossLedger =
    let span = createFiberSpan 1 80.0 standardSmf28
        b = computeSpanLossBudget span 4 // 4 splices
        a1 = assertRealNear "Bulk fiber loss is 16.0 dB" 16.0 b.fiberBulkLossDb 0.01
        a2 = assertRealNear "Splice loss is 0.2 dB" 0.20 b.spliceLossDb 0.01
        a3 = assertRealNear "Total loss is ~18.9 dB" 18.9 b.totalSpanLossDb 0.1
    in makeCaseResult "testSpanLossLedger" [a1, a2, a3] 0.4

runSuiteTestLinkBudget :: TestSuiteResult
runSuiteTestLinkBudget = makeSuiteResult "TestLinkBudget" [testSpanLossLedger]

