implementation module Etalon.Tests.TestSubseaDisasterTrace

/*
 * TestSubseaDisasterTrace.icl: Subsea disaster trace verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSubseaDisasterTrace
import Etalon.Simulation.SubseaDisasterTrace


testSubseaTrace :: TestCaseResult
testSubseaTrace =
    let dem = generateDiversionDemands 20
        a1 = assertIntEq "Generated 20 diversion demands" 20 (length dem)
    in makeCaseResult "testSubseaTrace" [a1] 0.4

runSuiteTestSubseaDisasterTrace :: TestSuiteResult
runSuiteTestSubseaDisasterTrace = makeSuiteResult "TestSubseaDisasterTrace" [testSubseaTrace]

