implementation module Etalon.Tests.TestFourWaveMixingEfficiency

/*
 * TestFourWaveMixingEfficiency.icl: Unit test implementation for Etalon.Impairments.FourWaveMixingEfficiency.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFourWaveMixingEfficiency
import Etalon.Impairments.FourWaveMixingEfficiency

testFwm :: Bool
testFwm = let trip = { f1Ghz = 193100.0, f2Ghz = 193150.0, f3Ghz = 193200.0 } in (computeFwmGeneration trip 16.5 0.08 3.0).generatedFreqGhz == 193050.0

runTest :: Bool
runTest = testFwm
