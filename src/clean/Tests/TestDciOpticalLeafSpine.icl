implementation module Etalon.Tests.TestDciOpticalLeafSpine

/*
 * TestDciOpticalLeafSpine.icl: Unit test implementation for Etalon.DciFabric.DciOpticalLeafSpine.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestDciOpticalLeafSpine
import Etalon.DciFabric.DciOpticalLeafSpine

testLeafSpine :: Bool
testLeafSpine = let f = createLeafSpineFabric 4 8 400.0 in f.spineCount == 4

runTest :: Bool
runTest = testLeafSpine
