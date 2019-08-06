implementation module Etalon.Topology.DynamicTopology

/*
 * DynamicTopology.icl: Dynamic link weight recalculation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.DynamicTopology
import Etalon.Types.Base
import Etalon.Topology.Graph

computeDynamicLinkWeight :: !OpticalLink !Real !Real -> Real
computeDynamicLinkWeight link currentOsnrMarginDb saturationRatio =
    let baseWeight = link.totalLengthKm
        marginPenalty = if (currentOsnrMarginDb < 2.0) 500.0 (if (currentOsnrMarginDb < 4.0) 100.0 0.0)
        congestionMultiplier = 1.0 + (saturationRatio * saturationRatio * 2.0)
    in (baseWeight + marginPenalty) * congestionMultiplier

evaluateMarginHealth :: !Real !Real -> Bool
evaluateMarginHealth measuredOsnr minRequiredOsnr =
    (measuredOsnr - minRequiredOsnr) >= 3.0
