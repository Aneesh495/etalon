implementation module Etalon.Tests.TestFiberCatalog

/*
 * TestFiberCatalog.icl: Fiber catalog retrieval verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestFiberCatalog
import Etalon.Physical.FiberCatalog


testFiberCatalogRetrieval :: TestCaseResult
testFiberCatalogRetrieval =
    let fibers = getAllCommercialFibers
        a1 = assertIntEq "20 commercial fibers in catalog" 20 (length fibers)
        (?Just smf) = findFiberByName "Corning SMF-28 ULL"
        a2 = assertRealNear "SMF-28 ULL attenuation is 0.160 dB/km" 0.160 smf.attenuationDbPerKm 0.001
    in makeCaseResult "testFiberCatalogRetrieval" [a1, a2] 0.5

runSuiteTestFiberCatalog :: TestSuiteResult
runSuiteTestFiberCatalog = makeSuiteResult "TestFiberCatalog" [testFiberCatalogRetrieval]

