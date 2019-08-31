definition module Etalon.Tests.TestIaRwaEngine

/*
 * TestIaRwaEngine.dcl: Impairment-Aware RWA provisioning and OSNR reach validation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Routing.ImpairmentAware
import Etalon.Topology.NetworkState
import Etalon.Topology.Graph
import Etalon.Types.Base

runSuiteTestIaRwaEngine :: TestSuiteResult
