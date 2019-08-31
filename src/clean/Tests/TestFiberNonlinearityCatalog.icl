implementation module Etalon.Tests.TestFiberNonlinearityCatalog

/*
 * TestFiberNonlinearityCatalog.icl: Nonlinearity catalog verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFiberNonlinearityCatalog
import Etalon.Models.FiberNonlinearityCatalog


testNonlinearity :: TestCaseResult
testNonlinearity =
    let p = getStandardSilicaParameters
        a1 = assertRealNear "Brillouin shift is ~10.85 GHz" 10.85 p.brillouinShiftGhz 0.01
    in makeCaseResult "testNonlinearity" [a1] 0.4

runSuiteTestFiberNonlinearityCatalog :: TestSuiteResult
runSuiteTestFiberNonlinearityCatalog = makeSuiteResult "TestFiberNonlinearityCatalog" [testNonlinearity]

