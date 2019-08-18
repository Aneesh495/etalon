implementation module Etalon.FlexGrid.SuperchannelSlotPlanner

/*
 * SuperchannelSlotPlanner.icl: Superchannel planning implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.FlexGrid.SuperchannelSlotPlanner

planSuperchannelSlots :: !SuperchannelConfig !Real -> SuperchannelAllocation
planSuperchannelSlots cfg anchorTHz =
    let scWidth = (real cfg.subcarrierCount) * (cfg.baudRateGbaud * 1.1)
        totWidth = scWidth + (2.0 * cfg.guardBandGhz)
        numSlots = toInt ((totWidth / 12.5) + 0.999)
    in { totalWidthGhz       = totWidth
       , flexibleGridSlots12_5 = numSlots
       , centerFrequencyTHz  = anchorTHz
       }
