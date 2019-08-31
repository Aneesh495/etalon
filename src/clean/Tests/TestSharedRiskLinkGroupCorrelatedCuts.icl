implementation module Etalon.Tests.TestSharedRiskLinkGroupCorrelatedCuts

/*
 * TestSharedRiskLinkGroupCorrelatedCuts.icl: Unit test implementation for Etalon.ProtectionSurv.SharedRiskLinkGroupCorrelatedCuts.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestSharedRiskLinkGroupCorrelatedCuts
import Etalon.ProtectionSurv.SharedRiskLinkGroupCorrelatedCuts

testSrlgConduit :: Bool
testSrlgConduit = let c = { conduitId = 1, fiberLinkIds = [101, 102], isBridgeCrossing = True } in doesSpanShareConduit c 101 102

runTest :: Bool
runTest = testSrlgConduit
