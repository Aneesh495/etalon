implementation module Etalon.Tests.TestFlexE

/*
 * TestFlexE.icl: FlexE 5G calendar slot allocation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFlexE
import Etalon.Otn.FlexE


testFlexECalendar :: TestCaseResult
testFlexECalendar =
    let s0 = createFlexEShim 1 1 // 1x 100G PHY = 20 slots
        s1 = allocateFlexESlots s0 101 4 // allocate 4x 5G = 20G
        allocated = [slot \ slot <- s1.calendarA | slot.isAllocated]
        a1 = assertIntEq "4 slots allocated" 4 (length allocated)
    in makeCaseResult "testFlexECalendar" [a1] 0.4

runSuiteTestFlexE :: TestSuiteResult
runSuiteTestFlexE = makeSuiteResult "TestFlexE" [testFlexECalendar]

