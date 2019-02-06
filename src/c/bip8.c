/**
 * bip8.c: Bit-Interleaved Parity 8 (BIP-8) implementation for OTN G.709.
 *
 * Section Monitoring (SM) and Path Monitoring (PM) parity verification.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

#include "etalon.h"

etalon_status_t etalon_otn_compute_bip8(const uint8_t* block, size_t len, uint8_t* out_bip8) {
    if (!block || !out_bip8) {
        return ETALON_ERROR_INVALID_PARAM;
    }

    uint8_t parity = 0;
    size_t i = 0;

    /* Unrolled 8-byte chunks for fast processing */
    for (; i + 8 <= len; i += 8) {
        parity ^= block[i]
                ^ block[i + 1]
                ^ block[i + 2]
                ^ block[i + 3]
                ^ block[i + 4]
                ^ block[i + 5]
                ^ block[i + 6]
                ^ block[i + 7];
    }

    /* Process remaining trailing bytes */
    for (; i < len; ++i) {
        parity ^= block[i];
    }

    *out_bip8 = parity;
    return ETALON_STATUS_OK;
}
