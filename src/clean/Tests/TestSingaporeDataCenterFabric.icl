implementation module Etalon.Tests.TestSingaporeDataCenterFabric

/*
 * TestSingaporeDataCenterFabric.icl: Unit test implementation for Etalon.Topologies.SingaporeDataCenterFabric.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestSingaporeDataCenterFabric
import Etalon.Topologies.SingaporeDataCenterFabric

testSingaporeDci :: Bool
testSingaporeDci = singaporeDataCenterFabricNodeCount == 8

runTest :: Bool
runTest = testSingaporeDci
