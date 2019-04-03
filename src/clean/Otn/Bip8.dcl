definition module Etalon.Otn.Bip8

/*
 * Bip8.dcl: Bit-Interleaved Parity 8 (BIP-8) parity verification for OTN G.709.
 *
 * Computes even bit parity across 8-bit columns of the OPUk/ODUk client payload.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame

// BIP-8 calculation primitives
computeBip8FromList    :: ![Int] -> Int
computeBip8FromArray   :: !.[Int] !Int !Int -> Int
computeFrameSectionBip :: !OtnFrame -> Int
computeFramePathBip    :: !OtnFrame -> Int

// Error count computation
countBip8Errors        :: !Int !Int -> Int
