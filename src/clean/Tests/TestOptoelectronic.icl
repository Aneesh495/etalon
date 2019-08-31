implementation module Etalon.Tests.TestOptoelectronic

/*
 * TestOptoelectronic.icl: TIA receiver front-end SNR test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOptoelectronic
import Etalon.Physical.OptoelectronicInterface


testOptoelectronicSnr :: TestCaseResult
testOptoelectronicSnr =
    let specs = defaultPinReceiverSpecs
        snrDb = computeElectricalSnrDb specs 0.001 // 1 mW
        a1 = assertBool "Electrical SNR > 30 dB for 1 mW received" True (snrDb > 30.0)
    in makeCaseResult "testOptoelectronicSnr" [a1] 0.4

runSuiteTestOptoelectronic :: TestSuiteResult
runSuiteTestOptoelectronic = makeSuiteResult "TestOptoelectronic" [testOptoelectronicSnr]

