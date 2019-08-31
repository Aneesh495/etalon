implementation module Etalon.Tests.TestSelfPhaseModulationProfile

/*
 * TestSelfPhaseModulationProfile.icl: Unit test implementation for Etalon.NonlinearOptics.SelfPhaseModulationProfile.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestSelfPhaseModulationProfile
import Etalon.NonlinearOptics.SelfPhaseModulationProfile

testSpm :: Bool
testSpm = let spm = computeSpmProfile 10.0 20.0 1.3 in spm.peakPowerMw == 10.0

runTest :: Bool
runTest = testSpm
