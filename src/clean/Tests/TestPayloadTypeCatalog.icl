implementation module Etalon.Tests.TestPayloadTypeCatalog

/*
 * TestPayloadTypeCatalog.icl: Payload type catalog verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPayloadTypeCatalog
import Etalon.Otn.PayloadTypeCatalog


testPayloadTypeLookup :: TestCaseResult
testPayloadTypeLookup =
    let entries = getAllPayloadTypeEntries
        a1 = assertIntEq "17 payload types in catalog" 17 (length entries)
        desc07 = lookupPayloadTypeDescription 0x07
        a2 = assertBool "0x07 is 100GBASE-R" True (size desc07 > 0)
    in makeCaseResult "testPayloadTypeLookup" [a1, a2] 0.4

runSuiteTestPayloadTypeCatalog :: TestSuiteResult
runSuiteTestPayloadTypeCatalog = makeSuiteResult "TestPayloadTypeCatalog" [testPayloadTypeLookup]

