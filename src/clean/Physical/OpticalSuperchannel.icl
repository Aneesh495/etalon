implementation module Etalon.Physical.OpticalSuperchannel

/*
 * OpticalSuperchannel.icl: Nyquist superchannel implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.OpticalSuperchannel
import Etalon.Types.Base
import Etalon.Types.Modulation

computeSubcarrierSpacingHz :: !SuperchannelConfig -> Real
computeSubcarrierSpacingHz cfg =
    cfg.subcarrierBaudRate * (1.0 + cfg.rrcRollOffBeta)

computeAggregateCapacityGbps :: !SuperchannelConfig -> Real
computeAggregateCapacityGbps cfg =
    let se = spectralEfficiency cfg.modulation
        subCapGbps = (cfg.subcarrierBaudRate * se) / 1.0e9
    in toReal cfg.subcarrierCount * subCapGbps

computeTotalOpticalBwHz :: !SuperchannelConfig -> Real
computeTotalOpticalBwHz cfg =
    let spacing = computeSubcarrierSpacingHz cfg
    in toReal cfg.subcarrierCount * spacing
