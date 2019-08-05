definition module Etalon.Otn.FlexE

/*
 * FlexE.dcl: OIF Flexible Ethernet Implementation Agreement (FlexE 2.1).
 *
 * Implements FlexE Shim calendar slot distribution:
 *   - 5 Gbps granular calendar slots across bonded 100G PHY instances
 *   - Calendar A and Calendar B hitless reconfiguration
 *   - Client sub-rating, channelization, and bonding
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: FlexECalendarSlot = {
    slotIndex          :: !Int,         // 0..19 per 100G PHY (each 5G)
    clientClientId     :: !Int,
    isAllocated        :: !Bool
}

:: FlexEShim = {
    shimGroupId        :: !Int,
    bondedPhyCount     :: !Int,         // e.g., 1..4 (100G..400G)
    activeCalendarIsA  :: !Bool,
    calendarA          :: ![FlexECalendarSlot],
    calendarB          :: ![FlexECalendarSlot]
}

createFlexEShim        :: !Int !Int -> FlexEShim
allocateFlexESlots     :: !FlexEShim !Int !Int -> FlexEShim
switchCalendar         :: !FlexEShim -> FlexEShim
