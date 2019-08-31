implementation module Etalon.Tests.TestOpticalPowerBudgetLedger

/*
 * TestOpticalPowerBudgetLedger.icl: Unit test implementation for Etalon.CarrierCore.OpticalPowerBudgetLedger.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOpticalPowerBudgetLedger
import Etalon.CarrierCore.OpticalPowerBudgetLedger

testPowerBudget :: Bool
testPowerBudget = let b = { txLaunchPowerDbm = 0.0, fiberAttenuationDb = 15.0, spliceLossDb = 0.5, connectorLossDb = 0.5, roadmInsertionLossDb = 2.0, agingMarginDb = 1.0, rxSensitivityDbm = -25.0 } in isPowerBudgetViable b

runTest :: Bool
runTest = testPowerBudget
