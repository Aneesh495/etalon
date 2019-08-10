definition module Etalon.Protection.PCycles

/*
 * PCycles.dcl: Pre-configured Protection Cycles (p-Cycles).
 *
 * Provides ring-like sub-50ms protection with mesh capacity efficiency:
 *   - On-cycle link failures: 1 protection path available
 *   - Straddling link failures: 2 disjoint protection paths available
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: PCycle = {
    cycleId            :: !Int,
    cycleLinks         :: ![Int],
    straddlingLinks    :: ![Int],
    reservedSlotMultiplier:: !Int
}

createPCycle           :: !Int ![Int] ![Int] !Int -> PCycle
isStraddlingLink       :: !PCycle !Int -> Bool
getProtectionCapacity  :: !PCycle !Int -> Int
