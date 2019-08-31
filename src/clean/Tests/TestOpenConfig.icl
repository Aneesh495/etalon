implementation module Etalon.Tests.TestOpenConfig

/*
 * TestOpenConfig.icl: OpenConfig JSON serialization test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpenConfig
import Etalon.Protocols.OpenConfig


testOpenConfigJson :: TestCaseResult
testOpenConfigJson =
    let cfg = { index = 1, description = "Client 100G", logicalChannelType = "PROT_ETHERNET", rateClass = "RATE_100G" }
        json = serializeOpenConfigJson cfg
        a1 = assertBool "Contains PROT_ETHERNET" True (size json > 0)
    in makeCaseResult "testOpenConfigJson" [a1] 0.4

runSuiteTestOpenConfig :: TestSuiteResult
runSuiteTestOpenConfig = makeSuiteResult "TestOpenConfig" [testOpenConfigJson]

