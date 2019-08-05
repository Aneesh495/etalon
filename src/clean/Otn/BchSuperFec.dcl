definition module Etalon.Otn.BchSuperFec

/*
 * BchSuperFec.dcl: Concatenated Super-FEC BCH(1020, 988) + BCH(2040, 1972).
 *
 * Implements high-gain multi-stage algebraic forward error correction:
 *   - Inner and outer interleaved BCH product codes
 *   - 9.35 dB Net Coding Gain (NCG) at 10^-15 post-FEC BER
 *   - Hard-decision iterative bounded distance decoding
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: BchCodecConfig = {
    innerN             :: !Int,         // 1020
    innerK             :: !Int,         // 988
    outerN             :: !Int,         // 2040
    outerK             :: !Int,         // 1972
    maxIterations      :: !Int          // e.g., 3 to 5 iterations
}

defaultSuperFecConfig  :: BchCodecConfig
computeBchNetCodingGainDb:: !BchCodecConfig -> Real
