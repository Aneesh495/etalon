implementation module Etalon.Tests.TestG654FiberSpecs

/*
 * TestG654FiberSpecs.icl: G.654 specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG654FiberSpecs
import Etalon.Standards.G654FiberSpecs


testG654 :: TestCaseResult
testG654 =
    let aeff = getG654MinEffectiveAreaUm2 G654E
        a1 = assertRealNear "G.654.E area is 125 um^2" 125.0 aeff 0.01
    in makeCaseResult "testG654" [a1] 0.4

runSuiteTestG654FiberSpecs :: TestSuiteResult
runSuiteTestG654FiberSpecs = makeSuiteResult "TestG654FiberSpecs" [testG654]

