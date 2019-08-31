implementation module Etalon.Tests.TestIetfTeTopologySpecs

/*
 * TestIetfTeTopologySpecs.icl: IETF TE specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestIetfTeTopologySpecs
import Etalon.Standards.IetfTeTopologySpecs


testIetfTe :: TestCaseResult
testIetfTe =
    let m = getTeDefaultMetric 250.4
        a1 = assertIntEq "250.4 km maps to metric 250" 250 m
    in makeCaseResult "testIetfTe" [a1] 0.4

runSuiteTestIetfTeTopologySpecs :: TestSuiteResult
runSuiteTestIetfTeTopologySpecs = makeSuiteResult "TestIetfTeTopologySpecs" [testIetfTe]

