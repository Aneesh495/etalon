definition module Etalon.Topology.LatencyModel

/*
 * LatencyModel.dcl: Carrier-grade end-to-end latency budget analyzer.
 *
 * Models precision transmission delay components:
 *   - Speed-of-light in silica: 4.9 microseconds per kilometer (n_group ~ 1.468)
 *   - Chromatic dispersion compensation fiber delay
 *   - ROADM WSS filter pass-through delay (~5 nanoseconds per node)
 *   - Coherent DSP and FEC processing latency (oFEC / CFEC ~ 2.5 to 10 microseconds)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Path

:: LatencyBreakdown = {
    fiberPropagationDelayUs :: !Real,
    roadmNodePassThroughUs  :: !Real,
    transponderDspFecDelayUs:: !Real,
    totalEndToEndDelayUs    :: !Real
}

computeDetailedLatency :: !OpticalRoute !Int !Real -> LatencyBreakdown
