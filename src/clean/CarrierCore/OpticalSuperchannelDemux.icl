implementation module Etalon.CarrierCore.OpticalSuperchannelDemux

/*
 * OpticalSuperchannelDemux.icl: Demux subcarrier implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.OpticalSuperchannelDemux

createSubcarrierDemux :: !Int !Real !Real -> DemuxSubcarrier
createSubcarrierDemux idx offset bw =
    { subcarrierIndex    = idx
    , localOscOffsetMhz  = offset
    , filterBandwidthGhz = bw
    }

isFrequencyOffsetRecoverable :: !DemuxSubcarrier -> Bool
isFrequencyOffsetRecoverable sc =
    (abs sc.localOscOffsetMhz) <= 1000.0
