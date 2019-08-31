implementation module Etalon.Tests.TestAshburnNorthernVirginiaCorridor

/*
 * TestAshburnNorthernVirginiaCorridor.icl: Unit test implementation for Etalon.Topologies.AshburnNorthernVirginiaCorridor.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestAshburnNorthernVirginiaCorridor
import Etalon.Topologies.AshburnNorthernVirginiaCorridor

testAshburnCorridor :: Bool
testAshburnCorridor = ashburnNorthernVirginiaCorridorNodeCount == 12

runTest :: Bool
runTest = testAshburnCorridor
