implementation module Etalon.Tests.TestPhysicalLayerIntrusionAlarm

/*
 * TestPhysicalLayerIntrusionAlarm.icl: Intrusion alarm verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPhysicalLayerIntrusionAlarm
import Etalon.Security.PhysicalLayerIntrusionAlarm


testIntrusion :: TestCaseResult
testIntrusion =
    let intru = isIntrusionSuspected 1500.0
        a1 = assertBool "Rapid SOP drift triggers intrusion alarm" True intru
    in makeCaseResult "testIntrusion" [a1] 0.4

runSuiteTestPhysicalLayerIntrusionAlarm :: TestSuiteResult
runSuiteTestPhysicalLayerIntrusionAlarm = makeSuiteResult "TestPhysicalLayerIntrusionAlarm" [testIntrusion]

