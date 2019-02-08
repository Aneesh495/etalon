/**
 * otn_frame.c: ITU-T G.709 OTN framing and overhead processing engine.
 *
 * Implements 4x4080 frame formatting, FAS synchronization, Section Monitoring (SM),
 * Path Monitoring (PM), payload de/multiplexing, and interleaved RS(255, 239) FEC.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

#include "etalon.h"
#include <string.h>

static const uint8_t ETALON_FAS_PATTERN[ETALON_OTN_FAS_SIZE] = {
    0xF6, 0xF6, 0xF6, 0x28, 0x28, 0x28
};

etalon_status_t etalon_otn_init_frame(etalon_otn_frame_t* frame) {
    if (!frame) return ETALON_ERROR_INVALID_PARAM;

    memset(frame, 0, sizeof(*frame));

    /* Insert Frame Alignment Signal (FAS) at Row 1, Columns 1..6 */
    memcpy(&frame->raw_data[0], ETALON_FAS_PATTERN, ETALON_OTN_FAS_SIZE);
    memcpy(frame->parsed_overhead.fas, ETALON_FAS_PATTERN, ETALON_OTN_FAS_SIZE);

    frame->raw_data[6] = 0x00; /* Initial MFAS */
    frame->parsed_overhead.mfas = 0x00;

    return ETALON_STATUS_OK;
}

etalon_status_t etalon_otn_set_payload(etalon_otn_frame_t* frame, const uint8_t* payload, size_t len) {
    if (!frame || !payload) return ETALON_ERROR_INVALID_PARAM;

    /* Total payload capacity is 4 rows * (3824 - 16) = 4 * 3808 = 15232 bytes */
    size_t max_payload = ETALON_OTN_ROWS * (ETALON_OTN_FEC_OFFSET - ETALON_OTN_PAYLOAD_OFFSET);
    size_t copy_len = len < max_payload ? len : max_payload;

    size_t src_offset = 0;
    for (int r = 0; r < ETALON_OTN_ROWS; ++r) {
        size_t row_start = (size_t)r * ETALON_OTN_COLS + ETALON_OTN_PAYLOAD_OFFSET;
        size_t row_cap = ETALON_OTN_FEC_OFFSET - ETALON_OTN_PAYLOAD_OFFSET;
        size_t to_copy = (src_offset + row_cap <= copy_len) ? row_cap : (copy_len > src_offset ? copy_len - src_offset : 0);

        if (to_copy > 0) {
            memcpy(&frame->raw_data[row_start], &payload[src_offset], to_copy);
            src_offset += to_copy;
        }
        if (to_copy < row_cap) {
            memset(&frame->raw_data[row_start + to_copy], 0, row_cap - to_copy);
        }
    }

    return ETALON_STATUS_OK;
}

etalon_status_t etalon_otn_encode_fec(etalon_otn_frame_t* frame) {
    if (!frame) return ETALON_ERROR_INVALID_PARAM;

    /*
     * ITU-T G.709 16-way byte interleaving:
     * Each row consists of 4080 bytes.
     * There are 16 interleaved RS(255, 239) sub-rows per row:
     * Sub-row i contains bytes at indices i, i+16, i+32, ..., i + 254*16.
     * The first 239 symbols are info symbols (columns 1..3824).
     * The last 16 symbols are parity symbols (columns 3825..4080).
     */
    for (int r = 0; r < ETALON_OTN_ROWS; ++r) {
        uint8_t* row_ptr = &frame->raw_data[r * ETALON_OTN_COLS];

        for (int sub = 0; sub < 16; ++sub) {
            uint8_t sub_codeword[255];

            /* Gather interleaved bytes */
            for (int k = 0; k < 239; ++k) {
                sub_codeword[k] = row_ptr[k * 16 + sub];
            }
            memset(&sub_codeword[239], 0, 16);

            /* Compute RS(255, 239) parity */
            etalon_rs255_239_encode(sub_codeword);

            /* Scatter computed 16 parity bytes into FEC area */
            for (int k = 0; k < 16; ++k) {
                row_ptr[(239 + k) * 16 + sub] = sub_codeword[239 + k];
            }
        }
    }

    frame->fec_encoded = true;
    return ETALON_STATUS_OK;
}

etalon_status_t etalon_otn_decode_fec(etalon_otn_frame_t* frame) {
    if (!frame) return ETALON_ERROR_INVALID_PARAM;

    uint32_t total_errors_corrected = 0;
    uint32_t uncorrectable_blocks = 0;

    for (int r = 0; r < ETALON_OTN_ROWS; ++r) {
        uint8_t* row_ptr = &frame->raw_data[r * ETALON_OTN_COLS];

        for (int sub = 0; sub < 16; ++sub) {
            uint8_t sub_codeword[255];

            /* Gather interleaved 255 symbols */
            for (int k = 0; k < 255; ++k) {
                sub_codeword[k] = row_ptr[k * 16 + sub];
            }

            uint32_t errs = 0;
            etalon_status_t st = etalon_rs255_239_decode(sub_codeword, &errs);
            if (st == ETALON_STATUS_OK) {
                if (errs > 0) {
                    total_errors_corrected += errs;
                    /* Scatter corrected bytes back */
                    for (int k = 0; k < 255; ++k) {
                        row_ptr[k * 16 + sub] = sub_codeword[k];
                    }
                }
            } else {
                uncorrectable_blocks++;
            }
        }
    }

    frame->corrected_bit_errors = total_errors_corrected;
    frame->uncorrectable_blocks = uncorrectable_blocks;

    if (uncorrectable_blocks > 0) {
        return ETALON_ERROR_FEC_UNCORRECTABLE;
    }
    return ETALON_STATUS_OK;
}
