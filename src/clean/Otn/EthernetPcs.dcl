definition module Etalon.Otn.EthernetPcs

/*
 * EthernetPcs.dcl: 100GBASE-R 64b/66b Physical Coding Sublayer.
 *
 * Implements IEEE 802.3ba 100G Ethernet PCS framing:
 *   - 2-bit synchronization header: 01 for data, 10 for control
 *   - 20 PCS multi-lane distribution (MLD) lanes
 *   - Alignment Marker (AM) insertion every 163840 66-bit blocks
 *   - Deskew buffer state machine
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: PcsSyncHeader =
    SyncDataHeader                     // 01b (0x1)
  | SyncControlHeader                  // 10b (0x2)
  | SyncInvalidHeader                  // 00b or 11b

:: PcsBlock = {
    header             :: !PcsSyncHeader,
    payloadWord64      :: !Int
}

:: PcsLaneStatus = {
    laneIndex          :: !Int,         // 0..19
    isBlockLocked      :: !Bool,
    isAligned          :: !Bool,
    skewDelayBlocks    :: !Int
}

createPcsDataBlock     :: !Int -> PcsBlock
createPcsControlBlock  :: !Int -> PcsBlock
verifySyncHeader       :: !Int -> PcsSyncHeader
checkMultiLaneAlignment:: ![PcsLaneStatus] -> Bool
