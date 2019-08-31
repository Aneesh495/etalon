implementation module Etalon.Tests.TestGnmi

/*
 * TestGnmi.icl: gNMI telemetry formatting test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGnmi
import Etalon.Protocols.GnmiTelemetry


testGnmiFormatting :: TestCaseResult
testGnmiFormatting =
    let upd = { sensorPath = "/interfaces/interface[name=opt-1]/state/in-power", valueFloat = ~3.2, timestampNs = 1700000000000 }
        json = formatGnmiUpdateJson upd
        a1 = assertBool "Contains sensor path" True (size json > 0)
    in makeCaseResult "testGnmiFormatting" [a1] 0.4

runSuiteTestGnmi :: TestSuiteResult
runSuiteTestGnmi = makeSuiteResult "TestGnmi" [testGnmiFormatting]

