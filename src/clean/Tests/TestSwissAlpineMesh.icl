implementation module Etalon.Tests.TestSwissAlpineMesh

/*
 * TestSwissAlpineMesh.icl: Unit test implementation for Etalon.Topologies.SwissAlpineMesh.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestSwissAlpineMesh
import Etalon.Topologies.SwissAlpineMesh

testSwissMesh :: Bool
testSwissMesh = swissAlpineMeshNodeCount == 8

runTest :: Bool
runTest = testSwissMesh
