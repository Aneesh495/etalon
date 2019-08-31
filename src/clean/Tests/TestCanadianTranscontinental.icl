implementation module Etalon.Tests.TestCanadianTranscontinental

/*
 * TestCanadianTranscontinental.icl: Canada transcontinental verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestCanadianTranscontinental
import Etalon.Topologies.CanadianTranscontinental


testCanada :: TestCaseResult
testCanada =
    let g = buildCanadianTranscontinental
        a1 = assertIntEq "Canada has 20 nodes" 20 g.nodeCount
        a2 = assertIntEq "Canada has 28 links" 28 g.linkCount
    in makeCaseResult "testCanada" [a1, a2] 0.5

runSuiteTestCanadianTranscontinental :: TestSuiteResult
runSuiteTestCanadianTranscontinental = makeSuiteResult "TestCanadianTranscontinental" [testCanada]

