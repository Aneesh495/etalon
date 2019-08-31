implementation module Etalon.Tests.TestSuperchannelSlotPlanner

/*
 * TestSuperchannelSlotPlanner.icl: Unit test implementation for Etalon.FlexGrid.SuperchannelSlotPlanner.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestSuperchannelSlotPlanner
import Etalon.FlexGrid.SuperchannelSlotPlanner

testSuperchannelPlanner :: Bool
testSuperchannelPlanner = let cfg = { subcarrierCount = 4, baudRateGbaud = 64.0, guardBandGhz = 10.0 } in (planSuperchannelSlots cfg 193.1).flexibleGridSlots12_5 > 0

runTest :: Bool
runTest = testSuperchannelPlanner
