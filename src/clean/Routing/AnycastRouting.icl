implementation module Etalon.Routing.AnycastRouting

/*
 * AnycastRouting.icl: Anycast routing implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Routing.AnycastRouting
import Etalon.Types.Base
import Etalon.Topology.Path

selectOptimalDataCenter :: ![AnycastDataCenter] -> ?AnycastDataCenter
selectOptimalDataCenter [] = ?None
selectOptimalDataCenter [dc:dcs] =
    let best = foldl pickBest dc dcs
    in ?Just best
where
    pickBest :: !AnycastDataCenter !AnycastDataCenter -> AnycastDataCenter
    pickBest current candidate =
        // Score: higher compute / distance
        let scoreCur = current.availableComputeGflops / maxReal current.opticalDistanceKm 1.0
            scoreCand = candidate.availableComputeGflops / maxReal candidate.opticalDistanceKm 1.0
        in if (scoreCand > scoreCur) candidate current
