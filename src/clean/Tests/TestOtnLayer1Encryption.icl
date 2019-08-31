implementation module Etalon.Tests.TestOtnLayer1Encryption

/*
 * TestOtnLayer1Encryption.icl: L1 encryption verification test implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Tests.TestFramework
import Etalon.Tests.TestOtnLayer1Encryption
import Etalon.Security.OtnLayer1Encryption


testL1Enc :: TestCaseResult
testL1Enc =
    let enc = isLayer1Encrypted Aes256Gcm
        a1 = assertBool "AES-256-GCM is active" True enc
    in makeCaseResult "testL1Enc" [a1] 0.4

runSuiteTestOtnLayer1Encryption :: TestSuiteResult
runSuiteTestOtnLayer1Encryption = makeSuiteResult "TestOtnLayer1Encryption" [testL1Enc]

