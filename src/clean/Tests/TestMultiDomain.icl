implementation module Etalon.Tests.TestMultiDomain

/*
 * TestMultiDomain.icl: Multi-domain ACTN optical architecture test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestMultiDomain
import Etalon.Topology.MultiDomainTopology


testMultiDomainEntities :: TestCaseResult
testMultiDomainEntities =
    let d1 = createOpticalDomain 1 "Domain-US-East" [1, 2] 10
        idl = createInterDomainLink 101 1 2 2 3 250.0
        a1 = assertIntEq "Domain ID is 1" 1 d1.domainId
        a2 = assertRealNear "IDL length is 250 km" 250.0 idl.lengthKm 0.01
    in makeCaseResult "testMultiDomainEntities" [a1, a2] 0.4

runSuiteTestMultiDomain :: TestSuiteResult
runSuiteTestMultiDomain = makeSuiteResult "TestMultiDomain" [testMultiDomainEntities]

