implementation module Etalon.Tests.TestRamanGainCoefficientSpectrum

/*
 * TestRamanGainCoefficientSpectrum.icl: Unit test implementation for Etalon.NonlinearOptics.RamanGainCoefficientSpectrum.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestRamanGainCoefficientSpectrum
import Etalon.NonlinearOptics.RamanGainCoefficientSpectrum

testRamanSpec :: Bool
testRamanSpec = (evaluateRamanGainAtStokesShift 13.2) == 1.0e-13

runTest :: Bool
runTest = testRamanSpec
