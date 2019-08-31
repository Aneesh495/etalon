implementation module Etalon.Tests.TestOtnDelayMeasurement

/*
 * TestOtnDelayMeasurement.icl: Unit test implementation for Etalon.Otn.OtnDelayMeasurement.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOtnDelayMeasurement
import Etalon.Otn.OtnDelayMeasurement

testDelayMeasurement :: Bool
testDelayMeasurement = let rec = computeDelayRecord 1000.0 2000.0 in rec.roundTripPs == 1000.0

runTest :: Bool
runTest = testDelayMeasurement
