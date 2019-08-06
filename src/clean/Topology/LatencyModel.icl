implementation module Etalon.Topology.LatencyModel

/*
 * LatencyModel.icl: Latency budget analyzer implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.LatencyModel
import Etalon.Types.Base
import Etalon.Topology.Path

computeDetailedLatency :: !OpticalRoute !Int !Real -> LatencyBreakdown
computeDetailedLatency route numRoadmNodes dspFecDelayUs =
    let fiberDelayUs = route.totalLengthKm * 4.90 // 4.9 us / km in standard SMF
        roadmDelayUs = toReal numRoadmNodes * 0.005 // 5 ns per ROADM
        totalDelayUs = fiberDelayUs + roadmDelayUs + dspFecDelayUs
    in {
        fiberPropagationDelayUs  = fiberDelayUs,
        roadmNodePassThroughUs   = roadmDelayUs,
        transponderDspFecDelayUs = dspFecDelayUs,
        totalEndToEndDelayUs     = totalDelayUs
    }
