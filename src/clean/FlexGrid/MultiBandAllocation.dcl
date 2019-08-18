definition module Etalon.FlexGrid.MultiBandAllocation

/*
 * MultiBandAllocation.dcl: C+L+S optical multi-band routing and spectrum assignment.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: OpticalBand = BandC | BandL | BandS

:: MultiBandSlot =
    { band       :: !OpticalBand
    , slotIndex  :: !Int
    , centerTHz  :: !Real
    , isOccupied :: !Bool
    }

:: MultiBandAllocationResult =
    { allocatedBand      :: !OpticalBand
    , startSlotIndex     :: !Int
    , slotCount          :: !Int
    , ramanInterBandLossDb :: !Real
    }

allocateMultiBandSlot :: !Int !Int -> MultiBandAllocationResult
