implementation module Etalon.Tests.TestOtnOverhead

/*
 * TestOtnOverhead.icl: OTU Section Monitoring and ODU Path Monitoring overhead insertion test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOtnOverhead
import Etalon.Otn.Overhead
import Etalon.Otn.Frame


testOverheadInsertionAndRead :: TestCaseResult
testOverheadInsertionAndRead =
    let f0 = createOtnFrame Otu2 1
        f1 = setSmBip8 f0 5
        f2 = setSmBdi f1 True
        a1 = assertIntEq "SM BIP-8 is 5" 5 (getFrameByte f2 1 9)
        a2 = assertBool "SM BDI bit set" True ((getFrameByte f2 1 10 bitand 0x08) <> 0)
    in makeCaseResult "testOverheadInsertionAndRead" [a1, a2] 0.5


runSuiteTestOtnOverhead :: TestSuiteResult
runSuiteTestOtnOverhead =
    makeSuiteResult "TestOtnOverhead" [testOverheadInsertionAndRead]
