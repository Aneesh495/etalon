implementation module Etalon.Tests.TestBrazilRnpBackbone

/*
 * TestBrazilRnpBackbone.icl: Unit test implementation for Etalon.Topologies.BrazilRnpBackbone.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestBrazilRnpBackbone
import Etalon.Topologies.BrazilRnpBackbone

testBrazilRnp :: Bool
testBrazilRnp = brazilRnpBackboneNodeCount == 12

runTest :: Bool
runTest = testBrazilRnp
