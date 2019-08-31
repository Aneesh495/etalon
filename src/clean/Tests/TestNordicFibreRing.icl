implementation module Etalon.Tests.TestNordicFibreRing

/*
 * TestNordicFibreRing.icl: Unit test implementation for Etalon.Topologies.NordicFibreRing.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestNordicFibreRing
import Etalon.Topologies.NordicFibreRing

testNordicRing :: Bool
testNordicRing = nordicFibreRingNodeCount == 10

runTest :: Bool
runTest = testNordicRing
