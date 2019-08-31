implementation module Etalon.Tests.TestMultiBandRouting

/*
 * TestMultiBandRouting.icl: C+L band band selection test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestMultiBandRouting
import Etalon.Routing.MultiBandRouting


testBandSelection :: TestCaseResult
testBandSelection =
    let b1 = selectOptimalBand 0.50 0.10
        b2 = selectOptimalBand 0.90 0.10
        a1 = assertBool "Selects C-band under low C-band occupancy" True (case b1 of BandC -> True; _ -> False)
        a2 = assertBool "Selects L-band when C-band is 90% full" True (case b2 of BandL -> True; _ -> False)
    in makeCaseResult "testBandSelection" [a1, a2] 0.4

runSuiteTestMultiBandRouting :: TestSuiteResult
runSuiteTestMultiBandRouting = makeSuiteResult "TestMultiBandRouting" [testBandSelection]

