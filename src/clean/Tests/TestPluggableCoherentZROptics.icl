implementation module Etalon.Tests.TestPluggableCoherentZROptics

/*
 * TestPluggableCoherentZROptics.icl: Unit test implementation for Etalon.DciFabric.PluggableCoherentZROptics.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestPluggableCoherentZROptics
import Etalon.DciFabric.PluggableCoherentZROptics

testPluggableZr :: Bool
testPluggableZr = let op = create400ZrOptic 1 in op.powerDrawWatts == 16.5

runTest :: Bool
runTest = testPluggableZr
