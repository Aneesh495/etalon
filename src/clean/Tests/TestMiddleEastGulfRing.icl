implementation module Etalon.Tests.TestMiddleEastGulfRing

/*
 * TestMiddleEastGulfRing.icl: Unit test implementation for Etalon.Topologies.MiddleEastGulfRing.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestMiddleEastGulfRing
import Etalon.Topologies.MiddleEastGulfRing

testMiddleEastRing :: Bool
testMiddleEastRing = middleEastGulfRingNodeCount == 8

runTest :: Bool
runTest = testMiddleEastRing
