implementation module Etalon.Simulation.CarrierChurnTraffic

/*
 * CarrierChurnTraffic.icl: Diurnal traffic implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Simulation.CarrierChurnTraffic
import Etalon.Types.Base

computeDiurnalLoadFactor :: !Real -> Real
computeDiurnalLoadFactor hourUtc =
    // Sinusoidal day/night variation centered around 14:00 peak
    let norm = (hourUtc - 14.0) * (2.0 * 3.141592653589793 / 24.0)
        base = 0.65 + 0.35 * cos norm
    in maxReal 0.20 (minReal 1.00 base)
