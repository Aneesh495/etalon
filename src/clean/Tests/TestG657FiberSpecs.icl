implementation module Etalon.Tests.TestG657FiberSpecs

/*
 * TestG657FiberSpecs.icl: G.657 specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG657FiberSpecs
import Etalon.Standards.G657FiberSpecs


testG657 :: TestCaseResult
testG657 =
    let r = getMinBendRadiusMm G657B3
        a1 = assertRealNear "G.657.B3 bend radius is 5.0 mm" 5.0 r 0.01
    in makeCaseResult "testG657" [a1] 0.4

runSuiteTestG657FiberSpecs :: TestSuiteResult
runSuiteTestG657FiberSpecs = makeSuiteResult "TestG657FiberSpecs" [testG657]

