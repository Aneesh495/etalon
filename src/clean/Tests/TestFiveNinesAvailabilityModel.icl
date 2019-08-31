implementation module Etalon.Tests.TestFiveNinesAvailabilityModel

/*
 * TestFiveNinesAvailabilityModel.icl: Unit test implementation for Etalon.CarrierSla.FiveNinesAvailabilityModel.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFiveNinesAvailabilityModel
import Etalon.CarrierSla.FiveNinesAvailabilityModel

testFiveNines :: Bool
testFiveNines = let a = evaluateServiceAvailability FiveNines 87600.0 0.8 in a.compliesWithSla

runTest :: Bool
runTest = testFiveNines
