implementation module Etalon.Tests.TestSpectrumFragmentationMetrics

/*
 * TestSpectrumFragmentationMetrics.icl: Unit test implementation for Etalon.FlexGrid.SpectrumFragmentationMetrics.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestSpectrumFragmentationMetrics
import Etalon.FlexGrid.SpectrumFragmentationMetrics

testFragmentationMetrics :: Bool
testFragmentationMetrics = let r1 = { isFree = True, slotCount = 10 } in (calculateFragmentation [r1]).freeSlots == 10

runTest :: Bool
runTest = testFragmentationMetrics
