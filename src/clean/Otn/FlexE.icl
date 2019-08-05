implementation module Etalon.Otn.FlexE

/*
 * FlexE.icl: FlexE shim implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.FlexE
import Etalon.Types.Base

createFlexEShim :: !Int !Int -> FlexEShim
createFlexEShim gId phys =
    let totalSlots = phys * 20
        emptyCal = [{ slotIndex = i, clientClientId = 0, isAllocated = False } \ i <- [0..totalSlots-1]]
    in {
        shimGroupId       = gId,
        bondedPhyCount    = phys,
        activeCalendarIsA = True,
        calendarA         = emptyCal,
        calendarB         = emptyCal
    }

allocateFlexESlots :: !FlexEShim !Int !Int -> FlexEShim
allocateFlexESlots shim cId slotCount =
    let updatedA = allocateInList shim.calendarA cId slotCount 0
    in { shim & calendarA = updatedA }
where
    allocateInList :: ![FlexECalendarSlot] !Int !Int !Int -> [FlexECalendarSlot]
    allocateInList [] _ _ _ = []
    allocateInList [s:ss] client targetCount allocatedSoFar
        | allocatedSoFar >= targetCount = [s: ss]
        | not s.isAllocated = [{ s & clientClientId = client, isAllocated = True }: allocateInList ss client targetCount (allocatedSoFar + 1)]
        = [s: allocateInList ss client targetCount allocatedSoFar]

switchCalendar :: !FlexEShim -> FlexEShim
switchCalendar shim =
    { shim & activeCalendarIsA = not shim.activeCalendarIsA }
