implementation module Etalon.Tests.TestAustralianAcademicAarnet

/*
 * TestAustralianAcademicAarnet.icl: Unit test implementation for Etalon.Topologies.AustralianAcademicAarnet.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestAustralianAcademicAarnet
import Etalon.Topologies.AustralianAcademicAarnet

testAustralianAarnet :: Bool
testAustralianAarnet = australianAcademicAarnetNodeCount == 10

runTest :: Bool
runTest = testAustralianAarnet
