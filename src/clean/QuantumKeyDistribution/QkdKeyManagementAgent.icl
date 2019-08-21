implementation module Etalon.QuantumKeyDistribution.QkdKeyManagementAgent

/*
 * QkdKeyManagementAgent.icl: KMS agent implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.QuantumKeyDistribution.QkdKeyManagementAgent

createEmptyKeyStore :: !Int -> QkdKeyStore
createEmptyKeyStore initialKeys =
    { totalKeysAvailable    = initialKeys
    , keyLengthBits         = 256
    , keyBufferLowWatermark = 100
    }

replenishKeys :: !QkdKeyStore !Int -> QkdKeyStore
replenishKeys ks count =
    { ks & totalKeysAvailable = ks.totalKeysAvailable + count }

requestEncryptionKey :: !QkdKeyStore !Int -> (!QkdKeyStore, !KeyRequestResult)
requestEncryptionKey ks reqId
    | ks.totalKeysAvailable > 0 =
        let nextKs = { ks & totalKeysAvailable = ks.totalKeysAvailable - 1 }
            res = { keyId = reqId, isKeyGranted = True, remainingKeys = nextKs.totalKeysAvailable }
        in (nextKs, res)
    = (ks, { keyId = reqId, isKeyGranted = False, remainingKeys = 0 })
