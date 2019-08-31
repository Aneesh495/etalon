implementation module Etalon.Tests.TestConstellationShapingOptimizer

/*
 * TestConstellationShapingOptimizer.icl: Unit test implementation for Etalon.CarrierCore.ConstellationShapingOptimizer.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestConstellationShapingOptimizer
import Etalon.CarrierCore.ConstellationShapingOptimizer

testPcs :: Bool
testPcs = let cfg = { constellationBaseQam = 64, shapingParameterNu = 0.02, targetEntropyBits = 5.2 } in (evaluatePcsConfig cfg).shapingGainDb > 0.0

runTest :: Bool
runTest = testPcs
