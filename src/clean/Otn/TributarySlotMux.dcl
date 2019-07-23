definition module Etalon.Otn.TributarySlotMux

/*
 * TributarySlotMux.dcl: ODUk Tributary Slot (TS) multiplexer.
 *
 * Implements ITU-T G.709 Chapter 19 multiplexing:
 *   - 1.25 Gbps Tributary Slots:
 *       ODU1  -> 2 TS of ODU2, 8 TS of ODU3, 80 TS of ODU4
 *       ODU2  -> 8 TS of ODU3, 80 TS of ODU4
 *       ODU2e -> 8 TS of ODU3, 80 TS of ODU4
 *       ODU3  -> 32 TS of ODU4
 *       ODUflex -> n TS (1 <= n <= 80)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: OduContainerType =
    Odu0              // 1.244 Gbps (1 TS)
  | Odu1              // 2.488 Gbps (2 TS)
  | Odu2              // 9.995 Gbps (8 TS)
  | Odu2e             // 10.356 Gbps (8 TS)
  | Odu3              // 40.150 Gbps (32 TS)
  | Odu4              // 104.355 Gbps (80 TS)
  | OduFlexClient !Int// n * 1.25G TS

:: TributarySlotAssignment = {
    clientServiceId   :: !Int,
    containerType     :: !OduContainerType,
    allocatedTsIndices:: ![Int]
}

:: *TributarySlotMux80 = {
    muxId             :: !Int,
    carrierContainer  :: !OduContainerType,
    totalSlots        :: !Int,         // 80 for ODU4
    occupiedSlotMask  :: ![Bool],      // 80-element boolean slot map
    activeAssignments :: ![TributarySlotAssignment]
}

createOdu4Mux          :: !Int -> *TributarySlotMux80
getRequiredSlotsCount  :: !OduContainerType -> Int
allocateTributarySlots :: !*TributarySlotMux80 !Int !OduContainerType -> (!*TributarySlotMux80, !?TributarySlotAssignment)
releaseTributarySlots  :: !*TributarySlotMux80 !Int -> *TributarySlotMux80
