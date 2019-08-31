implementation module Etalon.Tests.TestForwardErrorCorrectionCatalog

/*
 * TestForwardErrorCorrectionCatalog.icl: FEC schemes verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestForwardErrorCorrectionCatalog
import Etalon.Models.ForwardErrorCorrectionCatalog


testFecSchemes :: TestCaseResult
testFecSchemes =
    let rs = getStandardG709RsFec
        ofec = getOpenFecScheme
        a1 = assertRealNear "RS NCG is 6.2 dB" 6.2 rs.netCodingGainDb 0.01
        a2 = assertRealNear "oFEC NCG is 11.1 dB" 11.1 ofec.netCodingGainDb 0.01
    in makeCaseResult "testFecSchemes" [a1, a2] 0.4

runSuiteTestForwardErrorCorrectionCatalog :: TestSuiteResult
runSuiteTestForwardErrorCorrectionCatalog = makeSuiteResult "TestForwardErrorCorrectionCatalog" [testFecSchemes]

