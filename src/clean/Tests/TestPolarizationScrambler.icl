implementation module Etalon.Tests.TestPolarizationScrambler

/*
 * TestPolarizationScrambler.icl: Unit test implementation for Etalon.CarrierCore.PolarizationScrambler.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestPolarizationScrambler
import Etalon.CarrierCore.PolarizationScrambler

testScrambler :: Bool
testScrambler = let s = createScrambler SynchronousScrambling 1000.0 in isScramblerEffective s

runTest :: Bool
runTest = testScrambler
