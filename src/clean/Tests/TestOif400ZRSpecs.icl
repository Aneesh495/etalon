implementation module Etalon.Tests.TestOif400ZRSpecs

/*
 * TestOif400ZRSpecs.icl: 400ZR specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOif400ZRSpecs
import Etalon.Standards.Oif400ZRSpecs


testOif :: TestCaseResult
testOif =
    let p = default400ZrParameters
        a1 = assertRealNear "400ZR baud rate is ~59.84 GBaud" 59.84375e9 p.operatingBaudRate 1.0e6
    in makeCaseResult "testOif" [a1] 0.4

runSuiteTestOif400ZRSpecs :: TestSuiteResult
runSuiteTestOif400ZRSpecs = makeSuiteResult "TestOif400ZRSpecs" [testOif]

