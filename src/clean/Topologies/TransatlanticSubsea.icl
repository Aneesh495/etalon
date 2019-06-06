implementation module Etalon.Topologies.TransatlanticSubsea

/*
 * TransatlanticSubsea.icl: Implementation of the Transatlantic submarine cable model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Amplifier
import Etalon.Physical.Roadm
import Etalon.Topology.Graph
import Etalon.Topologies.TransatlanticSubsea

getSubseaRepeaterGainDb :: -> Real
getSubseaRepeaterGainDb = subseaRepeaterSpacingKm * 0.15 // 60 km * 0.15 dB/km = 9.0 dB gain

buildSubseaTopology :: -> *OpticalGraph
buildSubseaTopology =
    let g0 = createEmptyGraph
        // Cable landing stations (CLS)
        clsWest = createCdcRoadmNode 1 "Virginia Beach CLS (USA)" 2 64
        clsEast = createCdcRoadmNode 2 "Saint-Hilaire CLS (France)" 2 64
        g1 = addNodeToGraph (addNodeToGraph g0 clsWest) clsEast
        // Build 110 fiber spans and repeaters
        spans = [createSubseaSpan idx \ idx <- [1..subseaRepeaterCount]]
        totalDist = subseaCableLengthKm
        totalLoss = subseaRepeaterCount * (subseaRepeaterSpacingKm * 0.15)
        linkFwd = {
            linkId          = 1,
            sourceNodeId    = 1,
            targetNodeId    = 2,
            spans           = spans,
            srlgList        = [999], // Dedicated subsea corridor
            operational     = True,
            totalDistanceKm = totalDist,
            totalLossDb     = totalLoss
        }
        linkRev = {
            linkId          = 2,
            sourceNodeId    = 2,
            targetNodeId    = 1,
            spans           = spans,
            srlgList        = [999],
            operational     = True,
            totalDistanceKm = totalDist,
            totalLossDb     = totalLoss
        }
        g2 = addLinkToGraph (addLinkToGraph g1 linkFwd) linkRev
    in g2
where
    createSubseaSpan :: !Int -> FiberSpan
    createSubseaSpan sId =
        createCustomSpan sId PureSilica subseaRepeaterSpacingKm 0.15 21.0 0.060 0.03 112.0 2.2e-20 (~2.0)
