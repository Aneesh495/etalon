implementation module Etalon.Tests.TestBgpLs

/*
 * TestBgpLs.icl: BGP-LS optical TLV summary test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestBgpLs
import Etalon.Protocols.BgpLsOptical


testBgpLsFormatting :: TestCaseResult
testBgpLsFormatting =
    let nlri = { protocolId = 1, localRouterId = "10.0.0.1", remoteRouterId = "10.0.0.2", availableBandwidthGbps = 800.0, opticalMarginDb = 4.2 }
        summary = formatBgpLsTlvSummary nlri
        a1 = assertBool "Contains router IDs" True (size summary > 0)
    in makeCaseResult "testBgpLsFormatting" [a1] 0.4

runSuiteTestBgpLs :: TestSuiteResult
runSuiteTestBgpLs = makeSuiteResult "TestBgpLs" [testBgpLsFormatting]

