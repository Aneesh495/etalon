implementation module Etalon.Tests.TestSuperchannel

/*
 * TestSuperchannel.icl: Nyquist superchannel capacity test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSuperchannel
import Etalon.Physical.OpticalSuperchannel


testSuperchannelCapacity :: TestCaseResult
testSuperchannelCapacity =
    let cfg = { subcarrierCount = 4, subcarrierBaudRate = 32.0e9, rrcRollOffBeta = 0.10, modulation = Mod16Qam }
        cap = computeAggregateCapacityGbps cfg
        a1 = assertRealNear "Capacity is ~512 Gbps for 4x32G 16-QAM" 512.0 cap 1.0
    in makeCaseResult "testSuperchannelCapacity" [a1] 0.4

runSuiteTestSuperchannel :: TestSuiteResult
runSuiteTestSuperchannel = makeSuiteResult "TestSuperchannel" [testSuperchannelCapacity]

