implementation module Etalon.Tests.TestSpectrumGrid

/*
 * TestSpectrumGrid.icl: ITU-T G.694.1 C and L band bounds test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSpectrumGrid
import Etalon.Topology.OpticalSpectrumGrid


testGridBoundaries :: TestCaseResult
testGridBoundaries =
    let inC = isFrequencyInCband 193.1e12
        inL = isFrequencyInLband 188.0e12
        a1 = assertBool "193.1 THz is in C-band" True inC
        a2 = assertBool "188.0 THz is in L-band" True inL
        a3 = assertBool "190.0 THz is not in C-band" False (isFrequencyInCband 190.0e12)
    in makeCaseResult "testGridBoundaries" [a1, a2, a3] 0.4

runSuiteTestSpectrumGrid :: TestSuiteResult
runSuiteTestSpectrumGrid = makeSuiteResult "TestSpectrumGrid" [testGridBoundaries]

