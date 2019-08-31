definition module Etalon.Tests.MasterSuite

/*
 * MasterSuite.dcl: Top-level Clean test executive.
 *
 * Executes all 46 test suites across the Etalon carrier DWDM/OTN stack.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework

runMasterSuite :: *TestRunnerState
