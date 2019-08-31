implementation module Etalon.Tests.TestCbrMapping

/*
 * TestCbrMapping.icl: Fibre Channel and CPRI CBR mapping test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestCbrMapping
import Etalon.Otn.CbrClientMapping


testCbrClientSpecs :: TestCaseResult
testCbrClientSpecs =
    let fc = getCbrSpecs CbrFibreChannel32G
        cpri = getCbrSpecs CbrCpriOption7
        a1 = assertRealNear "FC-32G bitrate is 28.05 Gbps" 28.05 fc.nominalBitrateGbps 0.01
        a2 = assertRealNear "CPRI-7 bitrate is 9.83 Gbps" 9.83 cpri.nominalBitrateGbps 0.01
    in makeCaseResult "testCbrClientSpecs" [a1, a2] 0.4

runSuiteTestCbrMapping :: TestSuiteResult
runSuiteTestCbrMapping = makeSuiteResult "TestCbrMapping" [testCbrClientSpecs]

