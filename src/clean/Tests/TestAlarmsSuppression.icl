implementation module Etalon.Tests.TestAlarmsSuppression

/*
 * TestAlarmsSuppression.icl: ITU-T G.798 hierarchical alarm suppression tree test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestAlarmsSuppression
import Etalon.Otn.AlarmsHierarchical


testRootCauseAlarmSuppression :: TestCaseResult
testRootCauseAlarmSuppression =
    let engine0 = createAlarmEngine
        // LOS at physical layer suppresses downstream LOF and AIS
        rawAlarms = [AlarmLossOfSignal, AlarmLossOfFrame, AlarmAlarmIndicationSignal]
        engine1 = correlateAlarms engine0 rawAlarms 101 0.0
        a1 = assertIntEq "Suppressed downstream alarms count is 2" 2 engine1.suppressedCount
        a2 = assertIntEq "Critical active unsuppressed alarms is 1 (LOS)" 1 (getActiveCriticalCount engine1)
    in makeCaseResult "testRootCauseAlarmSuppression" [a1, a2] 0.5


runSuiteTestAlarmsSuppression :: TestSuiteResult
runSuiteTestAlarmsSuppression =
    makeSuiteResult "TestAlarmsSuppression" [testRootCauseAlarmSuppression]
