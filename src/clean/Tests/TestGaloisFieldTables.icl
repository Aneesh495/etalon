implementation module Etalon.Tests.TestGaloisFieldTables

/*
 * TestGaloisFieldTables.icl: Galois field fast math verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestGaloisFieldTables
import Etalon.Otn.GaloisFieldTables


testGfMath :: TestCaseResult
testGfMath =
    let prod = gfMultiplyFast 2 4
        a1 = assertIntEq "2 * 4 in GF(2^8) is 8" 8 prod
        inv = gfInverseFast 1
        a2 = assertIntEq "Inverse of 1 is 1" 1 inv
    in makeCaseResult "testGfMath" [a1, a2] 0.4

runSuiteTestGaloisFieldTables :: TestSuiteResult
runSuiteTestGaloisFieldTables = makeSuiteResult "TestGaloisFieldTables" [testGfMath]

