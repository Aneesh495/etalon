implementation module Etalon.Tests.TestQuantumBitErrorRate

/*
 * TestQuantumBitErrorRate.icl: Unit test implementation for Etalon.QuantumKeyDistribution.QuantumBitErrorRate.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestQuantumBitErrorRate
import Etalon.QuantumKeyDistribution.QuantumBitErrorRate

testQber :: Bool
testQber = let p = { signalIntensityMu = 0.5, decoyIntensityNu = 0.1, channelLossDb = 5.0, detectorEfficiency = 0.2 } in (evaluateQberAndSkr p).quantumBitErrorRate > 0.0

runTest :: Bool
runTest = testQber
