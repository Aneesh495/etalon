definition module Etalon.FlexGrid.SuperchannelSlotPlanner

/*
 * SuperchannelSlotPlanner.dcl: Multi-subcarrier Terabit superchannel spectrum planner.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: SuperchannelConfig =
    { subcarrierCount :: !Int
    , baudRateGbaud   :: !Real
    , guardBandGhz    :: !Real
    }

:: SuperchannelAllocation =
    { totalWidthGhz       :: !Real
    , flexibleGridSlots12_5 :: !Int
    , centerFrequencyTHz  :: !Real
    }

planSuperchannelSlots :: !SuperchannelConfig !Real -> SuperchannelAllocation
