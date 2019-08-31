implementation module Etalon.Tests.TestDublinHyperscaleRing

/*
 * TestDublinHyperscaleRing.icl: Unit test implementation for Etalon.Topologies.DublinHyperscaleRing.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestDublinHyperscaleRing
import Etalon.Topologies.DublinHyperscaleRing

testDublinRing :: Bool
testDublinRing = dublinHyperscaleRingNodeCount == 10

runTest :: Bool
runTest = testDublinRing
