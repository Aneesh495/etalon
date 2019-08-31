implementation module Etalon.Tests.TestG798EquipmentSpecs

/*
 * TestG798EquipmentSpecs.icl: G.798 equipment specs verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestG798EquipmentSpecs
import Etalon.Standards.G798EquipmentSpecs


testG798 :: TestCaseResult
testG798 =
    let isTerm = isTerminalFunction OtuTrailTermination
        a1 = assertBool "OTU trail termination is terminal" True isTerm
    in makeCaseResult "testG798" [a1] 0.4

runSuiteTestG798EquipmentSpecs :: TestSuiteResult
runSuiteTestG798EquipmentSpecs = makeSuiteResult "TestG798EquipmentSpecs" [testG798]

