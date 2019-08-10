implementation module Etalon.Protection.PCycles

/*
 * PCycles.icl: p-Cycle implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protection.PCycles
import Etalon.Types.Base

createPCycle :: !Int ![Int] ![Int] !Int -> PCycle
createPCycle cId cLinks sLinks slotW = {
    cycleId                = cId,
    cycleLinks             = cLinks,
    straddlingLinks        = sLinks,
    reservedSlotMultiplier = slotW
 }

isStraddlingLink :: !PCycle !Int -> Bool
isStraddlingLink pCycle linkId =
    isMember linkId pCycle.straddlingLinks
where
    isMember _ [] = False
    isMember x [y:ys]
        | x == y = True
        = isMember x ys

getProtectionCapacity :: !PCycle !Int -> Int
getProtectionCapacity pCycle linkId =
    if (isStraddlingLink pCycle linkId) 2
    (if (isMember linkId pCycle.cycleLinks) 1 0)
where
    isMember _ [] = False
    isMember x [y:ys]
        | x == y = True
        = isMember x ys
