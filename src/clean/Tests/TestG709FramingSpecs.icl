implementation module Etalon.Tests.TestG709FramingSpecs

/*
 * TestG709FramingSpecs.icl: G.709 framing specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG709FramingSpecs
import Etalon.Standards.G709FramingSpecs


testG709 :: TestCaseResult
testG709 =
    let r4 = getOtuNominalBitrateGbps 4
        a1 = assertRealNear "OTU4 bitrate is ~111.8 Gbps" 111.81 r4 0.1
    in makeCaseResult "testG709" [a1] 0.4

runSuiteTestG709FramingSpecs :: TestSuiteResult
runSuiteTestG709FramingSpecs = makeSuiteResult "TestG709FramingSpecs" [testG709]

