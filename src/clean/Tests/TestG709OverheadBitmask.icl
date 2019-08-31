implementation module Etalon.Tests.TestG709OverheadBitmask

/*
 * TestG709OverheadBitmask.icl: ITU-T G.709 Section 15 bitmask parsing of FAS, MFAS, SM, and PM test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG709OverheadBitmask
import Etalon.Protocols.G709OverheadParser
import Etalon.Otn.Frame


testOverheadSummaryParsing :: TestCaseResult
testOverheadSummaryParsing =
    let f = createOtnFrame Otu4 1
        summary = parseFullOverheadSummary f
        a1 = assertBool "FAS is aligned (0xF6F6F6282828)" True summary.frameAlignmentOk
        a2 = assertIntEq "MFAS is 0 on initialization" 0 summary.multiFrameIndicator
    in makeCaseResult "testOverheadSummaryParsing" [a1, a2] 0.5


runSuiteTestG709OverheadBitmask :: TestSuiteResult
runSuiteTestG709OverheadBitmask =
    makeSuiteResult "TestG709OverheadBitmask" [testOverheadSummaryParsing]
