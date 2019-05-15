implementation module Etalon.Protection.SharedMesh

/*
 * SharedMesh.icl: Implementation of Shared Mesh Restoration and backup pooling.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Path
import Etalon.Topology.Graph
import Etalon.Protection.SharedMesh

createEmptyPool :: !Int -> SharedMeshPool
createEmptyPool pId = {
    poolId            = pId,
    reservations      = [],
    totalSharedSlices = 0
}

canShareBackupSlice :: !SharedMeshPool !Int ![Int] !Int !Int -> Bool
canShareBackupSlice pool linkId primarySrlgs start len =
    // Backup slices can be shared on 'linkId' if all existing reservations overlapping
    // with [start .. start + len] belong to primary paths that are SRLG-disjoint
    let overlapping = [r \\ r <- pool.reservations | isMember linkId r.reservedLinkIds && intervalsOverlap r.startSlice r.sliceCount start len]
    in all (\r -> areSrlgSetsDisjoint r.primarySrlgs primarySrlgs) overlapping
where
    intervalsOverlap :: !Int !Int !Int !Int -> Bool
    intervalsOverlap s1 l1 s2 l2 =
        not ((s1 + l1 <= s2) || (s2 + l2 <= s1))

    areSrlgSetsDisjoint :: ![Int] ![Int] -> Bool
    areSrlgSetsDisjoint s1 s2 =
        isEmpty [x \\ x <- s1 | isMember x s2]

addBackupReservation :: !SharedMeshPool !Int !Int ![Int] ![Int] !Int !Int -> SharedMeshPool
addBackupReservation pool bId pId srlgs links start len =
    let newRes = {
            backupPathId    = bId,
            primaryPathId   = pId,
            primarySrlgs    = srlgs,
            reservedLinkIds = links,
            startSlice      = start,
            sliceCount      = len
        }
    in { pool & reservations = pool.reservations ++ [newRes],
                totalSharedSlices = pool.totalSharedSlices + len }

removeBackupReservation :: !SharedMeshPool !Int -> SharedMeshPool
removeBackupReservation pool targetBackupId =
    let rem = [r \\ r <- pool.reservations | r.backupPathId <> targetBackupId]
    in { pool & reservations = rem }

computeSharingEfficiency :: !SharedMeshPool -> Real
computeSharingEfficiency pool
    | isEmpty pool.reservations = 1.0
    = let uniqueDedicatedSlices = sum [r.sliceCount \\ r <- pool.reservations]
          actualPooledSlices = pool.totalSharedSlices
      in if (actualPooledSlices <= 0) 1.0 ((toReal uniqueDedicatedSlices) / (toReal actualPooledSlices))
