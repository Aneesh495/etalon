implementation module Etalon.Tests.TestOpticalSupervisoryChannel

/*
 * TestOpticalSupervisoryChannel.icl: Unit test implementation for Etalon.Amplifiers.OpticalSupervisoryChannel.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOpticalSupervisoryChannel
import Etalon.Amplifiers.OpticalSupervisoryChannel

testOscTelemetry :: Bool
testOscTelemetry = let f = createOscFrame Osc1510Nm 1 -12.0 5.0 250.0 False 1 in f.spanId == 1

runTest :: Bool
runTest = testOscTelemetry
