implementation module Etalon.Tests.TestHelsinkiArcticSubseaGateway

/*
 * TestHelsinkiArcticSubseaGateway.icl: Unit test implementation for Etalon.Topologies.HelsinkiArcticSubseaGateway.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestHelsinkiArcticSubseaGateway
import Etalon.Topologies.HelsinkiArcticSubseaGateway

testHelsinkiGateway :: Bool
testHelsinkiGateway = helsinkiArcticSubseaGatewayNodeCount == 8

runTest :: Bool
runTest = testHelsinkiGateway
