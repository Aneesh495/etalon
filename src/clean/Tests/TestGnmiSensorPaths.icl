implementation module Etalon.Tests.TestGnmiSensorPaths

/*
 * TestGnmiSensorPaths.icl: Unit test implementation for Etalon.Protocols.GnmiSensorPaths.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestGnmiSensorPaths
import Etalon.Protocols.GnmiSensorPaths

testGnmiPaths :: Bool
testGnmiPaths = let p = getEdfaInputPowerSensorPath 1 in p.sampleIntervalMs == 1000

runTest :: Bool
runTest = testGnmiPaths
