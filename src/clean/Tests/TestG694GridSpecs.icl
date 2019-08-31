implementation module Etalon.Tests.TestG694GridSpecs

/*
 * TestG694GridSpecs.icl: G.694.1 grid specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG694GridSpecs
import Etalon.Standards.G694GridSpecs


testG694 :: TestCaseResult
testG694 =
    let f = computeAnchorFreqHz 0
        a1 = assertRealNear "Anchor frequency is 193.1 THz" 193.1e12 f 1.0e6
    in makeCaseResult "testG694" [a1] 0.4

runSuiteTestG694GridSpecs :: TestSuiteResult
runSuiteTestG694GridSpecs = makeSuiteResult "TestG694GridSpecs" [testG694]

