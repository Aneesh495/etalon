implementation module Etalon.Tests.TestCoherentTransceiver

/*
 * TestCoherentTransceiver.icl: Coherent transceiver DSP feasibility test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestCoherentTransceiver
import Etalon.Physical.CoherentTransceiver


testTransceiverCapabilities :: TestCaseResult
testTransceiverCapabilities =
    let xcv100 = create100GTransceiver 1
        xcv400 = create400GTransceiver 2
        xcv800 = create800GTransceiver 3
        qSnr = computeQuantizationSnrDb xcv400.dacSpecs.enobBits
        a1 = assertBool "Quantization SNR > 40 dB for 6.8 ENOB" True (qSnr > 40.0)
        feas = evaluateDspFeasibility xcv400 10000.0 5.0 Mod16Qam
        a2 = assertBool "400G transceiver handles 10000 ps/nm CD" True feas
    in makeCaseResult "testTransceiverCapabilities" [a1, a2] 0.5

runSuiteTestCoherentTransceiver :: TestSuiteResult
runSuiteTestCoherentTransceiver = makeSuiteResult "TestCoherentTransceiver" [testTransceiverCapabilities]

