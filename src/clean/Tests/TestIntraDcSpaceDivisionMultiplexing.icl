implementation module Etalon.Tests.TestIntraDcSpaceDivisionMultiplexing

/*
 * TestIntraDcSpaceDivisionMultiplexing.icl: Unit test implementation for Etalon.DciFabric.IntraDcSpaceDivisionMultiplexing.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestIntraDcSpaceDivisionMultiplexing
import Etalon.DciFabric.IntraDcSpaceDivisionMultiplexing

testMcfSdm :: Bool
testMcfSdm = let mcf = create7CoreMcf 10.0 in mcf.coreCount == 7

runTest :: Bool
runTest = testMcfSdm
