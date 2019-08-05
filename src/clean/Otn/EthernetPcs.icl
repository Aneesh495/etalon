implementation module Etalon.Otn.EthernetPcs

/*
 * EthernetPcs.icl: 100GBASE-R PCS implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.EthernetPcs
import Etalon.Types.Base

createPcsDataBlock :: !Int -> PcsBlock
createPcsDataBlock payload = {
    header        = SyncDataHeader,
    payloadWord64 = payload
 }

createPcsControlBlock :: !Int -> PcsBlock
createPcsControlBlock payload = {
    header        = SyncControlHeader,
    payloadWord64 = payload
 }

verifySyncHeader :: !Int -> PcsSyncHeader
verifySyncHeader h =
    case h of
        1 -> SyncDataHeader
        2 -> SyncControlHeader
        _ -> SyncInvalidHeader

checkMultiLaneAlignment :: ![PcsLaneStatus] -> Bool
checkMultiLaneAlignment lanes =
    let allLocked = foldr (&&) True [l.isBlockLocked \ l <- lanes]
        allAligned = foldr (&&) True [l.isAligned \ l <- lanes]
    in allLocked && allAligned
