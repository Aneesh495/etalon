/**
 * test_c_subsystem.c: Comprehensive unit and integration verification for libetalon.
 *
 * Rigorously verifies:
 *  - BIP-8 bit-interleaved parity
 *  - Reed-Solomon RS(255, 239) encoding, syndrome computation, and multi-byte error correction
 *  - ITU-T G.709 4x4080 OTN framing and 16-way interleaved FEC
 *  - Gaussian Noise (GN) physical-layer non-linear Kerr impairment modeling
 *  - Fast ROADM WSS cross-connect switching and sub-50ms protection failover
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

#include "etalon.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

static int g_tests_run = 0;
static int g_tests_passed = 0;

#define TEST_ASSERT(cond, msg) do { \
    g_tests_run++; \
    if (!(cond)) { \
        fprintf(stderr, "FAIL: %s (at %s:%d)\n", msg, __FILE__, __LINE__); \
        exit(1); \
    } else { \
        g_tests_passed++; \
    } \
} while (0)

static void test_bip8(void) {
    printf("[TEST] Running BIP-8 parity checks...\n");

    uint8_t data1[8] = {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80};
    uint8_t bip1 = 0;
    TEST_ASSERT(etalon_otn_compute_bip8(data1, sizeof(data1), &bip1) == ETALON_STATUS_OK, "BIP8 compute ok");
    TEST_ASSERT(bip1 == 0xFF, "BIP8 expected 0xFF for one-hot powers of 2");

    uint8_t data2[4] = {0xAA, 0x55, 0xAA, 0x55};
    uint8_t bip2 = 0;
    TEST_ASSERT(etalon_otn_compute_bip8(data2, sizeof(data2), &bip2) == ETALON_STATUS_OK, "BIP8 compute ok");
    TEST_ASSERT(bip2 == 0x00, "BIP8 expected 0x00 for self-canceling bytes");
}

static void test_rs255_239(void) {
    printf("[TEST] Running Reed-Solomon RS(255, 239) error correction verification...\n");

    uint8_t codeword[255];
    memset(codeword, 0, sizeof(codeword));

    /* Populate 239 info symbols with pseudo-random pattern */
    for (int i = 0; i < 239; ++i) {
        codeword[i] = (uint8_t)((i * 37 + 11) & 0xFF);
    }

    uint8_t original[255];
    memcpy(original, codeword, 239);

    /* Encode codeword */
    TEST_ASSERT(etalon_rs255_239_encode(codeword) == ETALON_STATUS_OK, "RS encode ok");
    memcpy(&original[239], &codeword[239], 16);

    /* Clean decode without errors */
    uint32_t corrected = 0;
    TEST_ASSERT(etalon_rs255_239_decode(codeword, &corrected) == ETALON_STATUS_OK, "RS decode zero errors");
    TEST_ASSERT(corrected == 0, "No errors reported on pristine codeword");
    TEST_ASSERT(memcmp(codeword, original, 255) == 0, "Codeword pristine match");

    /* Inject 1, 2, 4, and up to 8 symbol errors and verify 100% recovery */
    for (int num_err = 1; num_err <= 8; ++num_err) {
        uint8_t corrupted[255];
        memcpy(corrupted, original, 255);

        for (int e = 0; e < num_err; ++e) {
            int err_idx = (e * 29 + 7) % 255;
            corrupted[err_idx] ^= (uint8_t)(0x5A + e);
        }

        uint32_t errs_fixed = 0;
        etalon_status_t st = etalon_rs255_239_decode(corrupted, &errs_fixed);
        TEST_ASSERT(st == ETALON_STATUS_OK, "RS decode successfully handled errors");
        TEST_ASSERT(errs_fixed == (uint32_t)num_err, "Reported correct number of symbol errors");
        TEST_ASSERT(memcmp(corrupted, original, 255) == 0, "Codeword perfectly restored after corruption");
    }
}

static void test_otn_frame(void) {
    printf("[TEST] Running ITU-T G.709 4x4080 OTN frame assembly and 16-way interleaved FEC...\n");

    etalon_otn_frame_t frame;
    TEST_ASSERT(etalon_otn_init_frame(&frame) == ETALON_STATUS_OK, "OTN frame init");
    TEST_ASSERT(frame.raw_data[0] == 0xF6 && frame.raw_data[3] == 0x28, "FAS header pattern matches G.709");

    /* Fill payload */
    uint8_t test_payload[1024];
    for (size_t i = 0; i < sizeof(test_payload); ++i) {
        test_payload[i] = (uint8_t)(i ^ 0xA5);
    }
    TEST_ASSERT(etalon_otn_set_payload(&frame, test_payload, sizeof(test_payload)) == ETALON_STATUS_OK, "Set payload ok");

    /* Apply full 16-way interleaved FEC */
    TEST_ASSERT(etalon_otn_encode_fec(&frame) == ETALON_STATUS_OK, "Encode frame FEC");
    TEST_ASSERT(frame.fec_encoded, "Frame marked as FEC encoded");

    /* Corrupt bytes across multiple interleaved rows */
    frame.raw_data[100] ^= 0x7E;
    frame.raw_data[500] ^= 0x33;
    frame.raw_data[4090] ^= 0xFF;

    /* Decode frame */
    TEST_ASSERT(etalon_otn_decode_fec(&frame) == ETALON_STATUS_OK, "Decode frame FEC");
    TEST_ASSERT(frame.corrected_bit_errors >= 3, "Errors successfully corrected");
}

static void test_gaussian_noise_model(void) {
    printf("[TEST] Running Gaussian Noise (GN) physical-layer impairment simulation...\n");

    etalon_fiber_span_t span;
    span.length_km = 80.0;
    span.loss_db_per_km = 0.20;
    span.dispersion_ps_nm_km = 17.0;
    span.dispersion_slope = 0.067;
    span.pmd_ps_sqrt_km = 0.05;
    span.effective_area_um2 = 80.0;
    span.non_linear_index_n2 = 2.6e-20;
    span.launch_power_dbm = 0.0; /* 1 mW */

    double nli_w = 0.0;
    TEST_ASSERT(etalon_gn_compute_nli(&span, ETALON_REF_FREQ_HZ, 64e9, 1e-3, 80, 50e9, &nli_w) == ETALON_STATUS_OK, "GN compute NLI");
    TEST_ASSERT(nli_w > 0.0 && nli_w < 1e-4, "NLI power within realistic physical bounds");

    /* Cascade of 5 spans with EDFAs */
    etalon_fiber_span_t spans[5];
    etalon_edfa_t amps[5];

    for (int i = 0; i < 5; ++i) {
        spans[i] = span;
        amps[i].gain_db = 16.0; /* 80km * 0.2 dB/km = 16 dB loss compensated */
        amps[i].noise_figure_db = 4.5;
        amps[i].max_output_power_dbm = 20.0;
        amps[i].dynamic_gain_tilt = 0.0;
        amps[i].ase_enabled = true;
    }

    etalon_lightpath_metrics_t metrics;
    TEST_ASSERT(etalon_evaluate_lightpath(spans, amps, 5, 0.0, 64e9, ETALON_MOD_DP_QPSK, ETALON_FEC_HARD_DECISION_7, &metrics) == ETALON_STATUS_OK, "Evaluate 5-span lightpath");
    TEST_ASSERT(metrics.feasible == true, "5-span 400km DP-QPSK lightpath is physically feasible");
    TEST_ASSERT(metrics.snr_db > 15.0, "OSNR exceeds 15 dB threshold for QPSK");
    TEST_ASSERT(metrics.estimated_ber < 1e-3, "Pre-FEC BER within HD-FEC 7% limit");
}

static void test_cross_connect_and_protection(void) {
    printf("[TEST] Running fast WSS cross-connect switching and sub-50ms protection failover...\n");

    etalon_cross_connect_entry_t matrix[10];
    memset(matrix, 0, sizeof(matrix));

    matrix[0].connection_id = 42;
    matrix[0].ingress_port = 1;
    matrix[0].egress_port = 2;
    matrix[0].start_slice = 100;
    matrix[0].slice_count = 8;
    matrix[0].active = true;

    uint64_t switch_ns = 0;
    TEST_ASSERT(etalon_xc_switch_fast(matrix, 10, 42, 5, &switch_ns) == ETALON_STATUS_OK, "Cross connect fast switch");
    TEST_ASSERT(matrix[0].egress_port == 5, "Egress port updated to protection port 5");

    etalon_protection_pair_t pair;
    memset(&pair, 0, sizeof(pair));
    pair.service_id = 101;
    pair.primary_path_id = 1;
    pair.backup_path_id = 2;
    pair.mode = ETALON_PROT_1_PLUS_1_OCH;
    pair.primary_active = true;

    uint64_t failover_ns = 0;
    TEST_ASSERT(etalon_protection_trigger_failover(&pair, ETALON_SIGNAL_LOSS_OF_SIGNAL, &failover_ns) == ETALON_STATUS_OK, "Failover on LOS");
    TEST_ASSERT(pair.primary_active == false, "Primary deactivated upon LOS defect");
    TEST_ASSERT(pair.switch_count == 1, "Switch count incremented");
    TEST_ASSERT(pair.failover_latency_us < 50000.0, "Failover latency strictly sub-50 milliseconds");
}

int main(void) {
    printf("=================================================================\n");
    printf("Etalon C Subsystem Verification Suite (libetalon)\n");
    printf("Version: %s\n", etalon_version());
    printf("=================================================================\n");

    test_bip8();
    test_rs255_239();
    test_otn_frame();
    test_gaussian_noise_model();
    test_cross_connect_and_protection();

    printf("=================================================================\n");
    printf("ALL TESTS PASSED: %d/%d assertions verified successfully.\n", g_tests_passed, g_tests_run);
    printf("=================================================================\n");
    return 0;
}
