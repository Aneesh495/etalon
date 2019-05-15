definition module Etalon.Protection.SharedMesh

/*
 * SharedMesh.dcl: Shared Mesh Restoration (SMR) and Backup Capacity Pooling.
 *
 * Implements backup capacity sharing where backup lightpaths can share the same
 * spectrum slices on optical links provided their primary lightpaths are SRLG-disjoint.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Path
import Etalon.Topology.Graph

:: SharedBackupReservation = {
    backupPathId       :: !Int,
    primaryPathId      :: !Int,
    primarySrlgs       :: ![Int],
    reservedLinkIds    :: ![Int],
    startSlice         :: !Int,
    sliceCount         :: !Int
}

:: SharedMeshPool = {
    poolId             :: !Int,
    reservations       :: ![SharedBackupReservation],
    totalSharedSlices  :: !Int
}

// Pool operations
createEmptyPool        :: !Int -> SharedMeshPool
canShareBackupSlice    :: !SharedMeshPool !Int ![Int] !Int !Int -> Bool
addBackupReservation   :: !SharedMeshPool !Int !Int ![Int] ![Int] !Int !Int -> SharedMeshPool
removeBackupReservation :: !SharedMeshPool !Int -> SharedMeshPool
computeSharingEfficiency :: !SharedMeshPool -> Real
