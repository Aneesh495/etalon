implementation module Etalon.Tests.TestKoreaResearchNetwork

/*
 * TestKoreaResearchNetwork.icl: Unit test implementation for Etalon.Topologies.KoreaResearchNetwork.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestKoreaResearchNetwork
import Etalon.Topologies.KoreaResearchNetwork

testKoreaNetwork :: Bool
testKoreaNetwork = koreaResearchNetworkNodeCount == 10

runTest :: Bool
runTest = testKoreaNetwork
