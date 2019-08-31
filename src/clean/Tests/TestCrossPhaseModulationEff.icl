implementation module Etalon.Tests.TestCrossPhaseModulationEff

/*
 * TestCrossPhaseModulationEff.icl: Unit test implementation for Etalon.Impairments.CrossPhaseModulationEff.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestCrossPhaseModulationEff
import Etalon.Impairments.CrossPhaseModulationEff

testXpm :: Bool
testXpm = let pair = { pumpFreqGhz = 193100.0, probeFreqGhz = 193150.0, pumpPowerMw = 5.0, walkOffParamPsPerKm = 0.5 } in (evaluateXpmEfficiency pair 80.0).freqSeparationGhz == 50.0

runTest :: Bool
runTest = testXpm
