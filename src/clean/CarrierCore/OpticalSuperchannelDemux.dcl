definition module Etalon.CarrierCore.OpticalSuperchannelDemux

/*
 * OpticalSuperchannelDemux.dcl: Coherent optical subcarrier demux and carrier recovery.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: DemuxSubcarrier =
    { subcarrierIndex   :: !Int
    , localOscOffsetMhz :: !Real
    , filterBandwidthGhz :: !Real
    }

createSubcarrierDemux :: !Int !Real !Real -> DemuxSubcarrier
isFrequencyOffsetRecoverable :: !DemuxSubcarrier -> Bool
