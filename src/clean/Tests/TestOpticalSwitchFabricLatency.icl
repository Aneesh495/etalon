implementation module Etalon.Tests.TestOpticalSwitchFabricLatency

/*
 * TestOpticalSwitchFabricLatency.icl: Unit test implementation for Etalon.DciFabric.OpticalSwitchFabricLatency.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOpticalSwitchFabricLatency
import Etalon.DciFabric.OpticalSwitchFabricLatency

testSwitchLatency :: Bool
testSwitchLatency = let spec = createSwitchFabricSpec SiliconPhotonicsMachZehnder in spec.switchingTimeUs == 0.05

runTest :: Bool
runTest = testSwitchLatency
