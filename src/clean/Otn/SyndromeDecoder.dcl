definition module Etalon.Otn.SyndromeDecoder

/*
 * SyndromeDecoder.dcl: Berlekamp-Massey and Chien search algebraic decoder.
 *
 * Implements full non-binary BCH / Reed-Solomon decoding over GF(2^8):
 *   1. Syndrome computation: S_i = r(alpha^i) for i in 1..2t
 *   2. Berlekamp-Massey: finds error locator polynomial Lambda(x)
 *   3. Chien search: finds roots of Lambda(x) to identify error positions
 *   4. Forney algorithm: evaluates error evaluator Omega(x) for error values
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: DecoderStatus =
    DecoderSuccess !Int                // Successfully corrected k errors (0 <= k <= t)
  | DecoderUncorrectable               // More than t errors detected (fail-stop)

:: DecodingResult = {
    status             :: !DecoderStatus,
    errorPositions     :: ![Int],
    errorMagnitudes    :: ![Int],
    correctedCodeword  :: ![Int]
}

computeSyndromes       :: ![Int] !Int -> [Int]
runBerlekampMassey     :: ![Int] !Int -> [Int]
runChienSearch         :: ![Int] !Int -> [Int]
runForneyAlgorithm     :: ![Int] ![Int] ![Int] -> [Int]
decodeCodewordFull     :: ![Int] !Int -> DecodingResult
