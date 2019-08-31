implementation module Etalon.Tests.TestRestconf

/*
 * TestRestconf.icl: RESTCONF URI path construction test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestRestconf
import Etalon.Protocols.RestconfClient


testRestconfPaths :: TestCaseResult
testRestconfPaths =
    let p = formatRestconfPath "ietf-network:networks" "network=optical"
        a1 = assertStringEq "Path is formatted correctly" "/restconf/data/ietf-network:networks/network=optical" p
    in makeCaseResult "testRestconfPaths" [a1] 0.4

runSuiteTestRestconf :: TestSuiteResult
runSuiteTestRestconf = makeSuiteResult "TestRestconf" [testRestconfPaths]

