implementation module Etalon.Tests.TestCoherentTransceiverPowerModel

/*
 * TestCoherentTransceiverPowerModel.icl: Unit test implementation for Etalon.DciFabric.CoherentTransceiverPowerModel.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestCoherentTransceiverPowerModel
import Etalon.DciFabric.CoherentTransceiverPowerModel

testTransceiverPower :: Bool
testTransceiverPower = let p = computeTransceiverPower Node5nm 800.0 in p.dspPowerWatts > 0.0

runTest :: Bool
runTest = testTransceiverPower
