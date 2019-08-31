implementation module Etalon.Tests.TestRamanPumpAllocation

/*
 * TestRamanPumpAllocation.icl: Unit test implementation for Etalon.Amplifiers.RamanPumpAllocation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestRamanPumpAllocation
import Etalon.Amplifiers.RamanPumpAllocation

testRamanAllocation :: Bool
testRamanAllocation = let p = createRamanPump 1450.0 300.0 True in p.pumpPowerMw == 300.0

runTest :: Bool
runTest = testRamanAllocation
