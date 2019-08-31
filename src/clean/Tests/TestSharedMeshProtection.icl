implementation module Etalon.Tests.TestSharedMeshProtection

/*
 * TestSharedMeshProtection.icl: 1:N Shared Mesh Protection backup spectrum reuse verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestSharedMeshProtection
import Etalon.Protection.SharedMesh


testSharedMeshReservations :: TestCaseResult
testSharedMeshReservations =
    let sm0 = createSharedMeshManager
        (sm1, res1) = reserveSharedBackup sm0 101 201 [1, 2] 0 8
        a1 = assertBool "First reservation successful" True res1.isReserved
        // Non-conflicting primary paths can share backup spectrum
        (sm2, res2) = reserveSharedBackup sm1 102 201 [3, 4] 0 8
        a2 = assertBool "Disjoint primary can share backup slot" True res2.isReserved
    in makeCaseResult "testSharedMeshReservations" [a1, a2] 0.6


runSuiteTestSharedMeshProtection :: TestSuiteResult
runSuiteTestSharedMeshProtection =
    makeSuiteResult "TestSharedMeshProtection" [testSharedMeshReservations]
