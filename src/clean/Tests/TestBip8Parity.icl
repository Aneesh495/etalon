implementation module Etalon.Tests.TestBip8Parity

/*
 * TestBip8Parity.icl: Bit-Interleaved Parity 8 computation across OPU payload test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestBip8Parity
import Etalon.Otn.Bip8
import Etalon.Otn.Frame


testBip8Calculation :: TestCaseResult
testBip8Calculation =
    let testBytes = [0xAA, 0x55, 0xFF, 0x00]
        parity = computeBip8 testBytes
        // 0xAA ^ 0x55 = 0xFF; 0xFF ^ 0xFF = 0x00; 0x00 ^ 0x00 = 0x00
        a1 = assertIntEq "BIP-8 of alternating bytes is 0" 0 parity
        diff = countBip8Mismatches 0x00 0x03
        a2 = assertIntEq "2 bit mismatches between 0x00 and 0x03" 2 diff
    in makeCaseResult "testBip8Calculation" [a1, a2] 0.4


runSuiteTestBip8Parity :: TestSuiteResult
runSuiteTestBip8Parity =
    makeSuiteResult "TestBip8Parity" [testBip8Calculation]
