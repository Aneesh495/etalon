definition module Etalon.Physical.Interleaver

/*
 * Interleaver.dcl: Periodic optical interleaver and deinterleaver.
 *
 * Implements Mach-Zehnder Interferometer (MZI) and Gires-Tournois etalon:
 *   - 50 GHz to 100 GHz channel separation
 *   - Periodic sinusoidal / Chebyshev filter transfer function
 *   - Group delay dispersion ripple and passband insertion loss
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: InterleaverConfig = {
    channelSpacingGhz :: !Real,        // 50.0 GHz or 100.0 GHz
    passbandRippleDb  :: !Real,
    stopbandRejectionDb:: !Real,
    insertionLossDb   :: !Real
}

evaluateMziTransmission :: !InterleaverConfig !Real !Bool -> Real
computeGroupDelayRipplePs:: !InterleaverConfig !Real -> Real
