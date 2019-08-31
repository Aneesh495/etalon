implementation module Etalon.Tests.TestColorlessDirectionlessContentionlessGrid

/*
 * TestColorlessDirectionlessContentionlessGrid.icl: Unit test implementation for Etalon.ProtectionSurv.ColorlessDirectionlessContentionlessGrid.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestColorlessDirectionlessContentionlessGrid
import Etalon.ProtectionSurv.ColorlessDirectionlessContentionlessGrid

testCdcRoadm :: Bool
testCdcRoadm = let r = createCdcRoadm 1 in r.isContentionless

runTest :: Bool
runTest = testCdcRoadm
