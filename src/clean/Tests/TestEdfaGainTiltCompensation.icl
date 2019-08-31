implementation module Etalon.Tests.TestEdfaGainTiltCompensation

/*
 * TestEdfaGainTiltCompensation.icl: Unit test implementation for Etalon.Amplifiers.EdfaGainTiltCompensation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestEdfaGainTiltCompensation
import Etalon.Amplifiers.EdfaGainTiltCompensation

testGainTilt :: Bool
testGainTilt = let cfg = createGainTiltConfig 20.0 23.0 in cfg.targetGainDb == 23.0

runTest :: Bool
runTest = testGainTilt
