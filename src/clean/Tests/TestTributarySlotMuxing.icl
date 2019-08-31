implementation module Etalon.Tests.TestTributarySlotMuxing

/*
 * TestTributarySlotMuxing.icl: ODUk 1.25G tributary slot allocation into 80-slot ODU4 containers test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestTributarySlotMuxing
import Etalon.Otn.TributarySlotMux


testOdu4SlotAllocation :: TestCaseResult
testOdu4SlotAllocation =
    let mux0 = createOdu4Mux 1
        (mux1, ?Just a1) = allocateTributarySlots mux0 101 Odu2 // 8 TS
        assert1 = assertIntEq "ODU2 consumes 8 tributary slots" 8 (length a1.allocatedTsIndices)
        (mux2, ?Just a2) = allocateTributarySlots mux1 102 Odu3 // 32 TS
        assert2 = assertIntEq "ODU3 consumes 32 tributary slots" 32 (length a2.allocatedTsIndices)
        mux3 = releaseTributarySlots mux2 101
        assert3 = assertIntEq "Remaining active assignment is 1" 1 (length mux3.activeAssignments)
    in makeCaseResult "testOdu4SlotAllocation" [assert1, assert2, assert3] 0.6


runSuiteTestTributarySlotMuxing :: TestSuiteResult
runSuiteTestTributarySlotMuxing =
    makeSuiteResult "TestTributarySlotMuxing" [testOdu4SlotAllocation]
