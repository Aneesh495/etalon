implementation module Etalon.Tests.TestQkdKeyManagementAgent

/*
 * TestQkdKeyManagementAgent.icl: Unit test implementation for Etalon.QuantumKeyDistribution.QkdKeyManagementAgent.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestQkdKeyManagementAgent
import Etalon.QuantumKeyDistribution.QkdKeyManagementAgent

testQkdKeyStore :: Bool
testQkdKeyStore = let ks = createEmptyKeyStore 500 in ks.totalKeysAvailable == 500

runTest :: Bool
runTest = testQkdKeyStore
