implementation module Etalon.Tests.TestG8251JitterSpecs

/*
 * TestG8251JitterSpecs.icl: G.8251 jitter specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG8251JitterSpecs
import Etalon.Standards.G8251JitterSpecs


testG8251 :: TestCaseResult
testG8251 =
    let ui = getMaxOutputJitterUi 100
        a1 = assertRealNear "100G output jitter is 0.30 UI" 0.30 ui 0.01
    in makeCaseResult "testG8251" [a1] 0.4

runSuiteTestG8251JitterSpecs :: TestSuiteResult
runSuiteTestG8251JitterSpecs = makeSuiteResult "TestG8251JitterSpecs" [testG8251]

