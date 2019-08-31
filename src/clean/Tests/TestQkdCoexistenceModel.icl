implementation module Etalon.Tests.TestQkdCoexistenceModel

/*
 * TestQkdCoexistenceModel.icl: Unit test implementation for Etalon.QuantumKeyDistribution.QkdCoexistenceModel.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestQkdCoexistenceModel
import Etalon.QuantumKeyDistribution.QkdCoexistenceModel

testQkdCoexistence :: Bool
testQkdCoexistence = let spec = { qkdBand = Quantum1310Nm, classicalLaunchPowerDbm = 0.0, fiberLengthKm = 25.0, demuxIsolationDb = 100.0 } in (evaluateQkdCoexistence spec).darkCountRatePerSec == 25.0

runTest :: Bool
runTest = testQkdCoexistence
