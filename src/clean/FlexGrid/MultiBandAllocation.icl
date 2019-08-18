implementation module Etalon.FlexGrid.MultiBandAllocation

/*
 * MultiBandAllocation.icl: Multi-band allocation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.FlexGrid.MultiBandAllocation

allocateMultiBandSlot :: !Int !Int -> MultiBandAllocationResult
allocateMultiBandSlot requestedSlots priorityBandCode =
    let band = if (priorityBandCode == 0) BandC (if (priorityBandCode == 1) BandL BandS)
        ramanLoss = case band of
            BandC -> 0.45
            BandL -> 0.15
            BandS -> 0.85
    in { allocatedBand        = band
       , startSlotIndex       = 1
       , slotCount            = requestedSlots
       , ramanInterBandLossDb = ramanLoss
       }
