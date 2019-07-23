implementation module Etalon.Otn.TributarySlotMux

/*
 * TributarySlotMux.icl: Tributary Slot Multiplexer implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.TributarySlotMux
import Etalon.Types.Base

getRequiredSlotsCount :: !OduContainerType -> Int
getRequiredSlotsCount Odu0              = 1
getRequiredSlotsCount Odu1              = 2
getRequiredSlotsCount Odu2              = 8
getRequiredSlotsCount Odu2e             = 8
getRequiredSlotsCount Odu3              = 32
getRequiredSlotsCount Odu4              = 80
getRequiredSlotsCount (OduFlexClient n) = max 1 (min 80 n)

createOdu4Mux :: !Int -> *TributarySlotMux80
createOdu4Mux mId = {
    muxId             = mId,
    carrierContainer  = Odu4,
    totalSlots        = 80,
    occupiedSlotMask  = [False \ _ <- [1..80]],
    activeAssignments = []
 }

allocateTributarySlots :: !*TributarySlotMux80 !Int !OduContainerType -> (!*TributarySlotMux80, !?TributarySlotAssignment)
allocateTributarySlots mux=:{occupiedSlotMask, activeAssignments} svcId cType =
    let reqCount = getRequiredSlotsCount cType
        freeIndices = [idx \ occ <- occupiedSlotMask & idx <- [1..80] | not occ]
    in if (length freeIndices < reqCount)
        (mux, ?None)
        (let allocated = take reqCount freeIndices
             newMask = [occ || isAllocated idx allocated \ occ <- occupiedSlotMask & idx <- [1..80]]
             newAssignment = {
                 clientServiceId    = svcId,
                 containerType      = cType,
                 allocatedTsIndices = allocated
             }
         in ({ mux &
             occupiedSlotMask  = newMask,
             activeAssignments = [newAssignment: activeAssignments]
         }, ?Just newAssignment))
where
    isAllocated :: !Int ![Int] -> Bool
    isAllocated _ [] = False
    isAllocated target [x:xs]
        | target == x = True
        = isAllocated target xs

releaseTributarySlots :: !*TributarySlotMux80 !Int -> *TributarySlotMux80
releaseTributarySlots mux=:{occupiedSlotMask, activeAssignments} svcId =
    let freedIndices = flatten [a.allocatedTsIndices \ a <- activeAssignments | a.clientServiceId == svcId]
        remaining = [a \ a <- activeAssignments | a.clientServiceId <> svcId]
        newMask = [occ && not (isFreed idx freedIndices) \ occ <- occupiedSlotMask & idx <- [1..80]]
    in { mux &
        occupiedSlotMask  = newMask,
        activeAssignments = remaining
    }
where
    isFreed :: !Int ![Int] -> Bool
    isFreed _ [] = False
    isFreed target [x:xs]
        | target == x = True
        = isFreed target xs
