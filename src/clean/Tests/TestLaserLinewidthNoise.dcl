definition module Etalon.Tests.TestLaserLinewidthNoise

/*
 * TestLaserLinewidthNoise.dcl: Wiener laser phase noise and CPE SNR penalties across modulation orders.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Physical.LaserPhaseNoise
import Etalon.Types.Modulation

runSuiteTestLaserLinewidthNoise :: TestSuiteResult
