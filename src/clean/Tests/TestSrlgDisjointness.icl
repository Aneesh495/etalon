implementation module Etalon.Tests.TestSrlgDisjointness

/*
 * TestSrlgDisjointness.icl: Shared Risk Link Group conduit risk and disjoint path checking test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSrlgDisjointness
import Etalon.Protocols.SrlgMatrix
import Etalon.Topology.Path


testSrlgCollisionDetection :: TestCaseResult
testSrlgCollisionDetection =
    let m0 = createSrlgMatrix
        m1 = registerSrlgGroup m0 500 SrlgBridgeCrossing "Hudson River Crossing" [101, 102] 5.0
        r1 = createOpticalRoute 1 1 2 [101] 50.0 800.0 0.25
        r2 = createOpticalRoute 2 1 2 [102] 60.0 900.0 0.30
        r3 = createOpticalRoute 3 1 2 [103] 70.0 1000.0 0.35
        a1 = assertBool "Paths sharing bridge are not SRLG-disjoint" False (arePathsSrlgDisjoint m1 r1 r2)
        a2 = assertBool "Path 1 and Path 3 are SRLG-disjoint" True (arePathsSrlgDisjoint m1 r1 r3)
    in makeCaseResult "testSrlgCollisionDetection" [a1, a2] 0.6


runSuiteTestSrlgDisjointness :: TestSuiteResult
runSuiteTestSrlgDisjointness =
    makeSuiteResult "TestSrlgDisjointness" [testSrlgCollisionDetection]
