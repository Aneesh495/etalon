implementation module Etalon.Tests.TestMultiBandAllocation

/*
 * TestMultiBandAllocation.icl: Unit test implementation for Etalon.FlexGrid.MultiBandAllocation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestMultiBandAllocation
import Etalon.FlexGrid.MultiBandAllocation

testMultiBand :: Bool
testMultiBand = let res = allocateMultiBandSlot 4 0 in res.slotCount == 4

runTest :: Bool
runTest = testMultiBand
