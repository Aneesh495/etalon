implementation module Etalon.Tests.TestG652FiberSpecs

/*
 * TestG652FiberSpecs.icl: G.652 specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG652FiberSpecs
import Etalon.Standards.G652FiberSpecs


testG652 :: TestCaseResult
testG652 =
    let att = getG652MaxAttenuationDb G652D 1550.0
        a1 = assertRealNear "G.652.D attenuation at 1550nm is 0.20 dB/km" 0.20 att 0.01
    in makeCaseResult "testG652" [a1] 0.4

runSuiteTestG652FiberSpecs :: TestSuiteResult
runSuiteTestG652FiberSpecs = makeSuiteResult "TestG652FiberSpecs" [testG652]

