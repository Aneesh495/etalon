implementation module Etalon.Tests.TestWavelengthTrackerTone

/*
 * TestWavelengthTrackerTone.icl: Unit test implementation for Etalon.CarrierCore.WavelengthTrackerTone.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestWavelengthTrackerTone
import Etalon.CarrierCore.WavelengthTrackerTone

testPilotTone :: Bool
testPilotTone = let t = createPilotTone 100.0 5.0 1 in detectPilotTone t 100.02

runTest :: Bool
runTest = testPilotTone
