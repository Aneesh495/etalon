implementation module Etalon.Tests.TestPCycles

/*
 * TestPCycles.icl: Pre-configured protection cycle capacity test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestPCycles
import Etalon.Protection.PCycles


testPCycleProtection :: TestCaseResult
testPCycleProtection =
    let pc = createPCycle 1 [1, 2, 3, 4] [5] 4
        a1 = assertIntEq "Straddling link has protection capacity 2" 2 (getProtectionCapacity pc 5)
        a2 = assertIntEq "On-cycle link has protection capacity 1" 1 (getProtectionCapacity pc 1)
        a3 = assertIntEq "Unrelated link has protection capacity 0" 0 (getProtectionCapacity pc 99)
    in makeCaseResult "testPCycleProtection" [a1, a2, a3] 0.4

runSuiteTestPCycles :: TestSuiteResult
runSuiteTestPCycles = makeSuiteResult "TestPCycles" [testPCycleProtection]

