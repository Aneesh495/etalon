implementation module Etalon.Tests.TestOduFlexRateAdaptation

/*
 * TestOduFlexRateAdaptation.icl: Unit test implementation for Etalon.Otn.OduFlexRateAdaptation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestOduFlexRateAdaptation
import Etalon.Otn.OduFlexRateAdaptation

testOduFlexHao :: Bool
testOduFlexHao = let ch = initOduFlexChannel 1 8 in ch.currentTributarySlots == 8

runTest :: Bool
runTest = testOduFlexHao
