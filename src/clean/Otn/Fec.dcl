definition module Etalon.Otn.Fec

/*
 * Fec.dcl: ITU-T G.709 Reed-Solomon RS(255, 239) Forward Error Correction.
 *
 * Implements Galois Field GF(2^8) arithmetic with field generator polynomial
 * p(x) = x^8 + x^4 + x^3 + x^2 + 1 (0x11D).
 * Provides 16-way byte interleaved encoding and decoding across 4x4080 OTN frames.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame

rsN                :== 255                // Codeword length
rsK                :== 239                // Information length
rsT                :== 8                  // Maximum correctable symbol errors
rsParityBytes      :== 16                 // Parity bytes per codeword

// Galois Field GF(2^8) arithmetic
gfMul              :: !Int !Int -> Int
gfDiv              :: !Int !Int -> Int
gfExpTable         :: ![Int]
gfLogTable         :: ![Int]

// RS(255, 239) codeword operations
rsEncodeCodeword   :: ![Int] -> [Int]     // Takes 239 bytes, returns 255 bytes (with 16 parity)
rsComputeSyndromes :: ![Int] -> [Int]     // Computes 16 syndromes S_0..S_15
rsHasSyndromes     :: ![Int] -> Bool

// Full OTN frame interleaved FEC
encodeOtnFrameFec  :: !*OtnFrame -> *OtnFrame
decodeOtnFrameFec  :: !*OtnFrame -> *OtnFrame
