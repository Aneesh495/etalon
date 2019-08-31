definition module Etalon.Tests.TestSub50msFailover

/*
 * TestSub50msFailover.dcl: Carrier-grade sub-50ms fault detection, signaling, and cross-connect latch.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Protection.FaultManager
import Etalon.Topology.NetworkState
import Etalon.Topology.Graph

runSuiteTestSub50msFailover :: TestSuiteResult
