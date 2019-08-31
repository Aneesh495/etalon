implementation module Etalon.Tests.TestOpticalSuperchannelDemux

/*
 * TestOpticalSuperchannelDemux.icl: Unit test implementation for Etalon.CarrierCore.OpticalSuperchannelDemux.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOpticalSuperchannelDemux
import Etalon.CarrierCore.OpticalSuperchannelDemux

testDemux :: Bool
testDemux = let sc = createSubcarrierDemux 1 250.0 64.0 in isFrequencyOffsetRecoverable sc

runTest :: Bool
runTest = testDemux
