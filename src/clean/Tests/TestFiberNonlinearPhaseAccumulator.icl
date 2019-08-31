implementation module Etalon.Tests.TestFiberNonlinearPhaseAccumulator

/*
 * TestFiberNonlinearPhaseAccumulator.icl: Unit test implementation for Etalon.CarrierCore.FiberNonlinearPhaseAccumulator.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFiberNonlinearPhaseAccumulator
import Etalon.CarrierCore.FiberNonlinearPhaseAccumulator

testNonlinearPhase :: Bool
testNonlinearPhase = let acc = { spanCount = 10, perSpanGammaWkm = 1.3, perSpanLengthKm = 80.0, launchPowerMw = 2.0 } in (computeTotalNonlinearPhase acc) > 0.0

runTest :: Bool
runTest = testNonlinearPhase
