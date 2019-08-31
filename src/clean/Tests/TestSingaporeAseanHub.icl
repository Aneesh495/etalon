implementation module Etalon.Tests.TestSingaporeAseanHub

/*
 * TestSingaporeAseanHub.icl: Unit test implementation for Etalon.Topologies.SingaporeAseanHub.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestSingaporeAseanHub
import Etalon.Topologies.SingaporeAseanHub

testSingaporeHub :: Bool
testSingaporeHub = singaporeAseanHubNodeCount == 12

runTest :: Bool
runTest = testSingaporeHub
