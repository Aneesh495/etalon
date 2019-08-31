implementation module Etalon.Tests.TestPacificSubsea

/*
 * TestPacificSubsea.icl: Trans-Pacific subsea cable verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPacificSubsea
import Etalon.Topologies.PacificSubsea


testPacificSubseaTopology :: TestCaseResult
testPacificSubseaTopology =
    let g = buildPacificSubseaCable
        a1 = assertIntEq "Pacific cable has 4 landing/BU nodes" 4 g.nodeCount
        a2 = assertRealNear "Total cable length is 12000 km" 12000.0 pacificCableLengthKm 0.01
    in makeCaseResult "testPacificSubseaTopology" [a1, a2] 0.4

runSuiteTestPacificSubsea :: TestSuiteResult
runSuiteTestPacificSubsea = makeSuiteResult "TestPacificSubsea" [testPacificSubseaTopology]

