implementation module Etalon.Tests.TestQFactorBER

/*
 * TestQFactorBER.icl: Q-factor and pre-FEC Bit Error Rate transformations test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestQFactorBER
import Etalon.Physical.QFactor
import Etalon.Types.Modulation


testQFactorBerCalculations :: TestCaseResult
testQFactorBerCalculations =
    let snrLinear = 20.0 // 13 dB SNR
        qDb = snrLinearToQFactorDb snrLinear
        ber = qFactorDbToBer qDb
        a1 = assertRealNear "Q-factor of 20 is ~13 dB" 13.0 qDb 0.5
        a2 = assertBool "BER is below 1e-3" True (ber < 1.0e-3)
    in makeCaseResult "testQFactorBerCalculations" [a1, a2] 0.5


runSuiteTestQFactorBER :: TestSuiteResult
runSuiteTestQFactorBER =
    makeSuiteResult "TestQFactorBER" [testQFactorBerCalculations]
