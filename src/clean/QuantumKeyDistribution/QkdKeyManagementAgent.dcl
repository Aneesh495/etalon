definition module Etalon.QuantumKeyDistribution.QkdKeyManagementAgent

/*
 * QkdKeyManagementAgent.dcl: ETSI GS QKD 014 Key Management System (KMS) agent for OTN encryption.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: QkdKeyStore =
    { totalKeysAvailable :: !Int
    , keyLengthBits      :: !Int
    , keyBufferLowWatermark :: !Int
    }

:: KeyRequestResult =
    { keyId        :: !Int
    , isKeyGranted :: !Bool
    , remainingKeys :: !Int
    }

createEmptyKeyStore :: !Int -> QkdKeyStore
replenishKeys :: !QkdKeyStore !Int -> QkdKeyStore
requestEncryptionKey :: !QkdKeyStore !Int -> (!QkdKeyStore, !KeyRequestResult)
