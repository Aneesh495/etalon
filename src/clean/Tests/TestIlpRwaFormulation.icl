implementation module Etalon.Tests.TestIlpRwaFormulation

/*
 * TestIlpRwaFormulation.icl: Multi-commodity flow ILP model construction and LP relaxation test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestIlpRwaFormulation
import Etalon.Optimization.IntegerLinearProgramming


testIlpModelVariables :: TestCaseResult
testIlpModelVariables =
    let m0 = createIlpModel False
        m1 = addVariable m0 "x_1_1" VarBinary 0.0 1.0 10.0
        m2 = addVariable m1 "x_1_2" VarBinary 0.0 1.0 15.0
        a1 = assertIntEq "Model has 2 variables" 2 m2.numVariables
        sol = solveLpRelaxation m2
        a2 = assertBool "Relaxation solution is optimal" True sol.isOptimal
    in makeCaseResult "testIlpModelVariables" [a1, a2] 0.5


runSuiteTestIlpRwaFormulation :: TestSuiteResult
runSuiteTestIlpRwaFormulation =
    makeSuiteResult "TestIlpRwaFormulation" [testIlpModelVariables]
