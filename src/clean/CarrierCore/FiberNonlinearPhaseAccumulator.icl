implementation module Etalon.CarrierCore.FiberNonlinearPhaseAccumulator

/*
 * FiberNonlinearPhaseAccumulator.icl: Nonlinear accumulator implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.FiberNonlinearPhaseAccumulator

computeTotalNonlinearPhase :: !MultiSpanAccumulator -> Real
computeTotalNonlinearPhase acc =
    let effLen = 22.0
        phasePerSpan = acc.perSpanGammaWkm * (acc.launchPowerMw * 1.0e-3) * (effLen * 1.0e3)
    in phasePerSpan * (real acc.spanCount)
