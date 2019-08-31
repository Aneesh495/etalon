definition module Etalon.Tests.TestG709OverheadBitmask

/*
 * TestG709OverheadBitmask.dcl: ITU-T G.709 Section 15 bitmask parsing of FAS, MFAS, SM, and PM.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Protocols.G709OverheadParser
import Etalon.Otn.Frame

runSuiteTestG709OverheadBitmask :: TestSuiteResult
