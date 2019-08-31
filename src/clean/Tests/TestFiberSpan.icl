implementation module Etalon.Tests.TestFiberSpan

/*
 * TestFiberSpan.icl: Fiber span attenuation, effective length, and chromatic dispersion test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFiberSpan
import Etalon.Physical.Fiber


testFiberEffectiveLength :: TestCaseResult
testFiberEffectiveLength =
    let smf = standardSmf28
        span = createFiberSpan 1 80.0 smf
        lEff = effectiveLengthKm span
        disp = spanTotalDispersionPsPerNm span
        a1 = assertRealNear "Effective length of 80km SMF-28 near 21.5 km" 21.5 lEff 0.5
        a2 = assertRealNear "Dispersion of 80km SMF-28 is 1360 ps/nm" 1360.0 disp 5.0
        a3 = assertRealNear "Total loss is 16.0 dB" 16.0 (spanTotalLossDb span) 0.1
    in makeCaseResult "testFiberEffectiveLength" [a1, a2, a3] 0.5


runSuiteTestFiberSpan :: TestSuiteResult
runSuiteTestFiberSpan =
    makeSuiteResult "TestFiberSpan" [testFiberEffectiveLength]
