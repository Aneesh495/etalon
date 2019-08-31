implementation module Etalon.Tests.TestOtnMapping

/*
 * TestOtnMapping.icl: Client signal mapping (GFP / CBR) into ODUflex containers test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOtnMapping
import Etalon.Otn.Mapping
import Etalon.Otn.Frame


testClientMappingGfp :: TestCaseResult
testClientMappingGfp =
    let f0 = createOtnFrame (OduFlex 8) 1
        payload = [0x55 \ _ <- [1..100]]
        f1 = mapClientSignal f0 ClientEth10G payload
        a1 = assertIntEq "Payload type is 0x09 (GFP)" 0x09 (getFrameByte f1 4 15)
    in makeCaseResult "testClientMappingGfp" [a1] 0.5


runSuiteTestOtnMapping :: TestSuiteResult
runSuiteTestOtnMapping =
    makeSuiteResult "TestOtnMapping" [testClientMappingGfp]
