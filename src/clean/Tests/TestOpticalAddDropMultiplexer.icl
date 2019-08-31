implementation module Etalon.Tests.TestOpticalAddDropMultiplexer

/*
 * TestOpticalAddDropMultiplexer.icl: OADM specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOpticalAddDropMultiplexer
import Etalon.Models.OpticalAddDropMultiplexer


testOadm :: TestCaseResult
testOadm =
    let specs = defaultOadmSpecs
        a1 = assertRealNear "Express loss is 1.5 dB" 1.5 specs.expressLossDb 0.01
    in makeCaseResult "testOadm" [a1] 0.4

runSuiteTestOpticalAddDropMultiplexer :: TestSuiteResult
runSuiteTestOpticalAddDropMultiplexer = makeSuiteResult "TestOpticalAddDropMultiplexer" [testOadm]

