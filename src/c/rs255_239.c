/**
 * rs255_239.c: ITU-T G.709 Reed-Solomon RS(255, 239) FEC Engine.
 *
 * Galois Field GF(2^8) arithmetic with field generator polynomial:
 * p(x) = x^8 + x^4 + x^3 + x^2 + 1 (0x11D).
 * Code generator polynomial:
 * g(x) = prod_{i=0}^{15} (x - alpha^i)
 * Capable of correcting up to t = 8 byte errors per 255-byte codeword.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

#include "etalon.h"
#include <string.h>

#define RS_N 255
#define RS_K 239
#define RS_T 8
#define RS_PARITY_BYTES (RS_N - RS_K) /* 16 */
#define GF_POLY 0x11D

static uint8_t gf_exp[512];
static uint8_t gf_log[256];
static bool gf_initialized = false;

/* Generator polynomial g(x) = prod_{i=0}^{15} (x - alpha^i) coefficients (degree 16 down to 0) */
static const uint8_t rs_gen_poly[RS_PARITY_BYTES + 1] = {
    1, 59, 13, 104, 189, 68, 209, 30, 8, 163, 65, 41, 229, 98, 50, 36, 59
};

static void gf_init_tables(void) {
    if (gf_initialized) return;

    uint32_t val = 1;
    for (int i = 0; i < 255; ++i) {
        gf_exp[i] = (uint8_t)val;
        gf_log[val] = (uint8_t)i;
        val <<= 1;
        if (val & 0x100) {
            val ^= GF_POLY;
        }
    }
    for (int i = 255; i < 512; ++i) {
        gf_exp[i] = gf_exp[i - 255];
    }
    gf_log[0] = 0; /* Clamped */
    gf_initialized = true;
}

static inline uint8_t gf_mul(uint8_t a, uint8_t b) {
    if (a == 0 || b == 0) return 0;
    return gf_exp[gf_log[a] + gf_log[b]];
}

static inline uint8_t gf_div(uint8_t a, uint8_t b) {
    if (a == 0) return 0;
    if (b == 0) return 0;
    int diff = (int)gf_log[a] - (int)gf_log[b];
    if (diff < 0) diff += 255;
    return gf_exp[diff];
}

etalon_status_t etalon_rs255_239_encode(uint8_t* codeword_255) {
    if (!codeword_255) return ETALON_ERROR_INVALID_PARAM;
    gf_init_tables();

    uint8_t parity[RS_PARITY_BYTES];
    memset(parity, 0, sizeof(parity));

    /* Polynomial division over GF(2^8) via LFSR */
    for (int i = 0; i < RS_K; ++i) {
        uint8_t feedback = codeword_255[i] ^ parity[0];
        if (feedback != 0) {
            for (int j = 0; j < RS_PARITY_BYTES - 1; ++j) {
                parity[j] = parity[j + 1] ^ gf_mul(feedback, rs_gen_poly[j + 1]);
            }
            parity[RS_PARITY_BYTES - 1] = gf_mul(feedback, rs_gen_poly[RS_PARITY_BYTES]);
        } else {
            memmove(&parity[0], &parity[1], RS_PARITY_BYTES - 1);
            parity[RS_PARITY_BYTES - 1] = 0;
        }
    }

    /* Append parity bytes to the end of the message */
    memcpy(&codeword_255[RS_K], parity, RS_PARITY_BYTES);
    return ETALON_STATUS_OK;
}

etalon_status_t etalon_rs255_239_decode(uint8_t* codeword_255, uint32_t* out_errors_corrected) {
    if (!codeword_255) return ETALON_ERROR_INVALID_PARAM;
    gf_init_tables();

    uint8_t syndromes[RS_PARITY_BYTES];
    bool has_syndrome = false;

    /* Compute syndromes S_i = sum_{j=0}^{254} c_j * alpha^(i * (254 - j)) */
    for (int i = 0; i < RS_PARITY_BYTES; ++i) {
        uint8_t sum = 0;
        for (int j = 0; j < RS_N; ++j) {
            if (codeword_255[j] != 0) {
                int exp_idx = (gf_log[codeword_255[j]] + (i * (254 - j))) % 255;
                sum ^= gf_exp[exp_idx];
            }
        }
        syndromes[i] = sum;
        if (sum != 0) has_syndrome = true;
    }

    if (!has_syndrome) {
        if (out_errors_corrected) *out_errors_corrected = 0;
        return ETALON_STATUS_OK;
    }

    /* Berlekamp-Massey algorithm */
    uint8_t C[RS_PARITY_BYTES + 1];
    uint8_t B[RS_PARITY_BYTES + 1];
    memset(C, 0, sizeof(C));
    memset(B, 0, sizeof(B));
    C[0] = 1;
    B[0] = 1;

    int L = 0;
    int m = 1;
    uint8_t b = 1;

    for (int n = 0; n < RS_PARITY_BYTES; ++n) {
        uint8_t d = syndromes[n];
        for (int i = 1; i <= L; ++i) {
            d ^= gf_mul(C[i], syndromes[n - i]);
        }
        if (d == 0) {
            m++;
        } else {
            uint8_t T[RS_PARITY_BYTES + 1];
            memcpy(T, C, sizeof(C));
            uint8_t factor = gf_div(d, b);
            for (int i = 0; i + m <= RS_PARITY_BYTES; ++i) {
                C[i + m] ^= gf_mul(factor, B[i]);
            }
            if (2 * L <= n) {
                L = n + 1 - L;
                memcpy(B, T, sizeof(T));
                b = d;
                m = 1;
            } else {
                m++;
            }
        }
    }

    if (L > RS_T) {
        return ETALON_ERROR_FEC_UNCORRECTABLE;
    }

    /* Chien search for error positions */
    int error_pos[RS_T];
    int err_count = 0;

    for (int pos = 0; pos < RS_N; ++pos) {
        int x_exp = (pos - 254) % 255;
        if (x_exp < 0) x_exp += 255;
        uint8_t x_inv = gf_exp[x_exp];

        uint8_t eval_val = 0;
        for (int j = 0; j <= L; ++j) {
            if (j == 0) {
                eval_val ^= C[0];
            } else {
                int term_exp = (gf_log[x_inv] * j) % 255;
                eval_val ^= gf_mul(C[j], gf_exp[term_exp]);
            }
        }

        if (eval_val == 0) {
            if (err_count < RS_T) {
                error_pos[err_count++] = pos;
            } else {
                return ETALON_ERROR_FEC_UNCORRECTABLE;
            }
        }
    }

    if (err_count != L) {
        return ETALON_ERROR_FEC_UNCORRECTABLE;
    }

    /* Compute error evaluator polynomial Omega(x) = S(x) * C(x) mod x^16 */
    uint8_t omega[RS_PARITY_BYTES];
    memset(omega, 0, sizeof(omega));
    for (int i = 0; i < RS_PARITY_BYTES; ++i) {
        for (int j = 0; j <= L; ++j) {
            if (i + j < RS_PARITY_BYTES) {
                omega[i + j] ^= gf_mul(syndromes[i], C[j]);
            }
        }
    }

    /* Forney algorithm */
    for (int k = 0; k < err_count; ++k) {
        int pos = error_pos[k];
        int x_k_exp = (254 - pos) % 255;
        if (x_k_exp < 0) x_k_exp += 255;
        uint8_t X_k = gf_exp[x_k_exp];

        int x_inv_exp = (pos - 254) % 255;
        if (x_inv_exp < 0) x_inv_exp += 255;
        uint8_t X_inv = gf_exp[x_inv_exp];

        /* Numerator Omega(X_inv) */
        uint8_t num = 0;
        for (int i = 0; i < RS_PARITY_BYTES; ++i) {
            if (i == 0) {
                num ^= omega[0];
            } else {
                int term_exp = (gf_log[X_inv] * i) % 255;
                num ^= gf_mul(omega[i], gf_exp[term_exp]);
            }
        }

        /* Denominator C'(X_inv) */
        uint8_t den = 0;
        for (int j = 1; j <= L; j += 2) {
            if (j == 1) {
                den ^= C[1];
            } else {
                int term_exp = (gf_log[X_inv] * (j - 1)) % 255;
                den ^= gf_mul(C[j], gf_exp[term_exp]);
            }
        }

        if (den == 0) {
            return ETALON_ERROR_FEC_UNCORRECTABLE;
        }

        uint8_t error_mag = gf_mul(gf_div(num, den), X_k);
        codeword_255[pos] ^= error_mag;
    }

    if (out_errors_corrected) *out_errors_corrected = (uint32_t)err_count;
    return ETALON_STATUS_OK;
}
