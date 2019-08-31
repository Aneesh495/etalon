implementation module Etalon.Tests.TestNetconfEditConfigPayloads

/*
 * TestNetconfEditConfigPayloads.icl: Unit test implementation for Etalon.Protocols.NetconfEditConfigPayloads.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestNetconfEditConfigPayloads
import Etalon.Protocols.NetconfEditConfigPayloads

testNetconfRpc :: Bool
testNetconfRpc = let rpc = buildNetconfCreateRpc 101 1 2 193100.0 50.0 2.5 in validateRpcParameters rpc

runTest :: Bool
runTest = testNetconfRpc
