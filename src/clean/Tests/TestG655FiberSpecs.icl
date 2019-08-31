implementation module Etalon.Tests.TestG655FiberSpecs

/*
 * TestG655FiberSpecs.icl: G.655 specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG655FiberSpecs
import Etalon.Standards.G655FiberSpecs


testG655 :: TestCaseResult
testG655 =
    let (dMin, dMax) = getG655DispersionRange 1550.0
        a1 = assertRealNear "G.655 min dispersion is 2.0" 2.0 dMin 0.01
    in makeCaseResult "testG655" [a1] 0.4

runSuiteTestG655FiberSpecs :: TestSuiteResult
runSuiteTestG655FiberSpecs = makeSuiteResult "TestG655FiberSpecs" [testG655]

