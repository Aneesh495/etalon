implementation module Etalon.Tests.TestMeanTimeToRepairSimulation

/*
 * TestMeanTimeToRepairSimulation.icl: Unit test implementation for Etalon.CarrierSla.MeanTimeToRepairSimulation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestMeanTimeToRepairSimulation
import Etalon.CarrierSla.MeanTimeToRepairSimulation

testMttr :: Bool
testMttr = let p = { travelTimeHours = 1.5, spliceTimeHours = 1.0, testTimeHours = 0.5 } in (calculateMttrHours p) == 3.0

runTest :: Bool
runTest = testMttr
