implementation module Etalon.Tests.TestOtnMultiStageMux

/*
 * TestOtnMultiStageMux.icl: Unit test implementation for Etalon.Otn.OtnMultiStageMux.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOtnMultiStageMux
import Etalon.Otn.OtnMultiStageMux

testOdu4Mux :: Bool
testOdu4Mux = let c = createEmptyOdu4Container 1 in c.totalSlots == 80

runTest :: Bool
runTest = testOdu4Mux
