implementation module Etalon.Tests.TestBertErrorInjector

/*
 * TestBertErrorInjector.icl: BERT injector verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestBertErrorInjector
import Etalon.Diagnostics.BertErrorInjector


testBert :: TestCaseResult
testBert =
    let bytes = injectErrorsInBlock [0x00] 1
        a1 = assertIntEq "First byte flipped to 0x01" 1 bytes.[0]
    in makeCaseResult "testBert" [a1] 0.4

runSuiteTestBertErrorInjector :: TestSuiteResult
runSuiteTestBertErrorInjector = makeSuiteResult "TestBertErrorInjector" [testBert]

