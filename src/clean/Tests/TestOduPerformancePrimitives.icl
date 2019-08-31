implementation module Etalon.Tests.TestOduPerformancePrimitives

/*
 * TestOduPerformancePrimitives.icl: ODU performance verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOduPerformancePrimitives
import Etalon.Monitoring.OduPerformancePrimitives


testOduPrim :: TestCaseResult
testOduPrim =
    let ses = isSeverelyErroredSecond 50
        a1 = assertBool "50 errors is SES" True ses
    in makeCaseResult "testOduPrim" [a1] 0.4

runSuiteTestOduPerformancePrimitives :: TestSuiteResult
runSuiteTestOduPerformancePrimitives = makeSuiteResult "TestOduPerformancePrimitives" [testOduPrim]

