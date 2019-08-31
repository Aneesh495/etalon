implementation module Etalon.Tests.TestTaiwanSemiconductorCorridor

/*
 * TestTaiwanSemiconductorCorridor.icl: Unit test implementation for Etalon.Topologies.TaiwanSemiconductorCorridor.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestTaiwanSemiconductorCorridor
import Etalon.Topologies.TaiwanSemiconductorCorridor

testTaiwanCorridor :: Bool
testTaiwanCorridor = taiwanSemiconductorCorridorNodeCount == 10

runTest :: Bool
runTest = testTaiwanCorridor
