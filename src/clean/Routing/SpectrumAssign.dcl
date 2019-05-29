definition module Etalon.Routing.SpectrumAssign

/*
 * SpectrumAssign.dcl: Spectrum Allocation Policies (RSA / RWA).
 *
 * Implements First-Fit, Best-Fit, and Minimum-Fragmentation spectrum assignment policies
 * enforcing the wavelength continuity and contiguity constraints across multi-hop lightpaths.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Path
import Etalon.Topology.NetworkState

:: AllocationPolicy =
    PolicyFirstFit
  | PolicyBestFit
  | PolicyExactFit
  | PolicyMinFragmentation

:: SpectrumAllocationResult = {
    allocatedSlot      :: !FrequencySlot,
    success            :: !Bool,
    searchedSlices     :: !Int,
    fragmentationDelta :: !Real
}

// Multi-hop intersection bitmap
computeLinkIntersectionBitmap  :: ![LinkSpectrumState] !OpticalRoute -> SpectrumBitmap
computeRouteIntersectionBitmap :: !WorldState !OpticalRoute -> SpectrumBitmap

// Policy assignment functions
assignSpectrumForRoute :: !WorldState !OpticalRoute !Int !AllocationPolicy -> SpectrumAllocationResult
findCommonContiguousSlots :: !SpectrumBitmap !Int -> [Int]
policyToString         :: !AllocationPolicy -> String
