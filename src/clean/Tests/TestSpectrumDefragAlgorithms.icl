implementation module Etalon.Tests.TestSpectrumDefragAlgorithms

/*
 * TestSpectrumDefragAlgorithms.icl: Unit test implementation for Etalon.FlexGrid.SpectrumDefragAlgorithms.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestSpectrumDefragAlgorithms
import Etalon.FlexGrid.SpectrumDefragAlgorithms

testDefragPlan :: Bool
testDefragPlan = let plan = generateHitlessDefragPlan [1] [10] in plan.totalSlotsSaved == 2

runTest :: Bool
runTest = testDefragPlan
