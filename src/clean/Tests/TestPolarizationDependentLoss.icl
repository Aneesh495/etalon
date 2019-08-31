implementation module Etalon.Tests.TestPolarizationDependentLoss

/*
 * TestPolarizationDependentLoss.icl: Unit test implementation for Etalon.Impairments.PolarizationDependentLoss.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestPolarizationDependentLoss
import Etalon.Impairments.PolarizationDependentLoss

testPdlCascade :: Bool
testPdlCascade = let e1 = { elementId = 1, meanPdlDb = 0.2 } in (cascadePdlElements [e1]).totalMeanPdlDb == 0.2

runTest :: Bool
runTest = testPdlCascade
