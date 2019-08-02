definition module Etalon.Physical.OpticalSuperchannel

/*
 * OpticalSuperchannel.dcl: Coherent Nyquist superchannel generator.
 *
 * Models multi-carrier superchannels sharing a contiguous optical slot:
 *   - Subcarrier frequency spacing Delta f_sub ~ R_sym * (1 + beta)
 *   - Root-Raised Cosine (RRC) pulse shaping filter transfer function
 *   - Aggregate throughput: N_sub * R_sym * SE
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation

:: SuperchannelConfig = {
    subcarrierCount    :: !Int,         // e.g., 4 or 8 subcarriers
    subcarrierBaudRate :: !Real,        // e.g., 32.0 GBaud or 64.0 GBaud
    rrcRollOffBeta     :: !Real,        // e.g., 0.10
    modulation         :: !ModulationFormat
}

computeSubcarrierSpacingHz :: !SuperchannelConfig -> Real
computeAggregateCapacityGbps:: !SuperchannelConfig -> Real
computeTotalOpticalBwHz    :: !SuperchannelConfig -> Real
