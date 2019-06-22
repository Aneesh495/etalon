implementation module Etalon.Protocols.SrlgMatrix

/*
 * SrlgMatrix.icl: SRLG collision engine implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protocols.SrlgMatrix
import Etalon.Types.Base
import Etalon.Topology.Path

createSrlgMatrix :: *SrlgMatrix
createSrlgMatrix = {
    groups        = [],
    linkToSrlgMap = [],
    totalGroups   = 0
 }

registerSrlgGroup :: !*SrlgMatrix !Int !SrlgRiskCategory !String ![Int] !Real -> *SrlgMatrix
registerSrlgGroup matrix=:{groups, linkToSrlgMap, totalGroups} sId cat desc members weight =
    let newGrp = {
            srlgId        = sId,
            category      = cat,
            description   = desc,
            memberLinkIds = members,
            riskWeight    = weight
        }
        updatedGroups = [newGrp: groups]
        updatedMap = updateLinkMappings linkToSrlgMap sId members
    in { matrix &
        groups        = updatedGroups,
        linkToSrlgMap = updatedMap,
        totalGroups   = totalGroups + 1
    }
where
    updateLinkMappings :: ![(!Int, ![Int])] !Int ![Int] -> [(!Int, ![Int])]
    updateLinkMappings m _ [] = m
    updateLinkMappings m sId [lId:rest] =
        let updatedEntry = case [srlgs \ (l, srlgs) <- m | l == lId] of
                []      -> (lId, [sId])
                [cur:_] -> (lId, [sId: cur])
            filtered = [(l, s) \ (l, s) <- m | l <> lId]
        in updateLinkMappings [updatedEntry: filtered] sId rest

getLinkSrlgs :: !SrlgMatrix !Int -> [Int]
getLinkSrlgs matrix targetLinkId =
    case [srlgs \ (lId, srlgs) <- matrix.linkToSrlgMap | lId == targetLinkId] of
        []      -> []
        [res:_] -> res

findCommonSrlgs :: !SrlgMatrix !OpticalRoute !OpticalRoute -> [Int]
findCommonSrlgs matrix r1 r2 =
    let srlgs1 = flatten [getLinkSrlgs matrix lId \ lId <- r1.linkSequence]
        srlgs2 = flatten [getLinkSrlgs matrix lId \ lId <- r2.linkSequence]
    in [s \ s <- srlgs1 | isMember s srlgs2]
where
    isMember :: !Int ![Int] -> Bool
    isMember _ [] = False
    isMember x [y:ys]
        | x == y = True
        = isMember x ys

arePathsSrlgDisjoint :: !SrlgMatrix !OpticalRoute !OpticalRoute -> Bool
arePathsSrlgDisjoint matrix r1 r2 =
    let commons = findCommonSrlgs matrix r1 r2
    in isEmpty commons

computeSrlgOverlapRisk :: !SrlgMatrix !OpticalRoute !OpticalRoute -> Real
computeSrlgOverlapRisk matrix r1 r2 =
    let commons = findCommonSrlgs matrix r1 r2
        weights = [getWeight matrix.groups sId \ sId <- commons]
    in foldr (+) 0.0 weights
where
    getWeight :: ![SrlgGroup] !Int -> Real
    getWeight [] _ = 0.0
    getWeight [g:rest] targetId
        | g.srlgId == targetId = g.riskWeight
        = getWeight rest targetId
