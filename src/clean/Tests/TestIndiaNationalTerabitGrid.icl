implementation module Etalon.Tests.TestIndiaNationalTerabitGrid

/*
 * TestIndiaNationalTerabitGrid.icl: Unit test implementation for Etalon.Topologies.IndiaNationalTerabitGrid.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestIndiaNationalTerabitGrid
import Etalon.Topologies.IndiaNationalTerabitGrid

testIndiaGrid :: Bool
testIndiaGrid = indiaNationalTerabitGridNodeCount == 14

runTest :: Bool
runTest = testIndiaGrid
