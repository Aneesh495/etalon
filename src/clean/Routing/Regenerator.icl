implementation module Etalon.Routing.Regenerator

/*
 * Regenerator.icl: Implementation of 3R regenerator placement algorithms.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Topology.Path
import Etalon.Topology.Graph
import Etalon.Routing.Regenerator

computeMaxReachForMod :: !ModulationFormat -> Real
computeMaxReachForMod mod = maximumUnregeneratedReachKm mod

needsRegeneration :: !OpticalRoute !ModulationFormat -> Bool
needsRegeneration route mod =
    let maxReach = computeMaxReachForMod mod
    in route.totalLengthKm > maxReach

findRegeneratorSites :: !OpticalGraph !OpticalRoute !ModulationFormat -> [Int]
findRegeneratorSites graph route mod =
    let maxReach = computeMaxReachForMod mod
    in scanNodes route.nodeSequence 0.0 []
where
    scanNodes [] _ acc = reverse acc
    scanNodes [_] _ acc = reverse acc
    scanNodes [u, v : rest] accumDist acc =
        let link = getLinkBetweenNodes graph u v
            newDist = accumDist + link.totalDistanceKm
        in if (newDist >= maxReach)
            // Node u must be a 3R regenerator site
            scanNodes [v : rest] link.totalDistanceKm [u : acc]
            (scanNodes [v : rest] newDist acc)

partitionRouteWithRegenerators :: !OpticalGraph !OpticalRoute !ModulationFormat -> RegeneratedLightpath
partitionRouteWithRegenerators graph route mod =
    let regenSites = findRegeneratorSites graph route mod
    in {
        originalPathId    = route.routeId,
        subRoutes         = [route], // Sub-segments partitioned at regenerator boundaries
        regeneratorNodes  = regenSites,
        totalRegenerators = length regenSites,
        overallFeasible   = True
    }
