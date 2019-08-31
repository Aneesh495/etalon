implementation module Etalon.Tests.TestIeee8023OpticalSpecs

/*
 * TestIeee8023OpticalSpecs.icl: IEEE 802.3 specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestIeee8023OpticalSpecs
import Etalon.Standards.Ieee8023OpticalSpecs


testIeee :: TestCaseResult
testIeee =
    let dist = getReachDistanceKm Pmd100GBaseLR4
        a1 = assertRealNear "LR4 reach is 10 km" 10.0 dist 0.01
    in makeCaseResult "testIeee" [a1] 0.4

runSuiteTestIeee8023OpticalSpecs :: TestSuiteResult
runSuiteTestIeee8023OpticalSpecs = makeSuiteResult "TestIeee8023OpticalSpecs" [testIeee]

