implementation module Etalon.Tests.TestHybridRamanEdfa

/*
 * TestHybridRamanEdfa.icl: Unit test implementation for Etalon.Amplifiers.HybridRamanEdfa.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestHybridRamanEdfa
import Etalon.Amplifiers.HybridRamanEdfa

testHybridRaman :: Bool
testHybridRaman = let ha = createHybridAmplifier 10.0 15.0 3.0 12.0 22.0 in ha.ramanOnOnGainDb == 10.0

runTest :: Bool
runTest = testHybridRaman
