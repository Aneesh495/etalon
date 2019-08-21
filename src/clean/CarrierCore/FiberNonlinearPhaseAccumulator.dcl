definition module Etalon.CarrierCore.FiberNonlinearPhaseAccumulator

/*
 * FiberNonlinearPhaseAccumulator.dcl: Multi-span nonlinear phase perturbation accumulator.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: MultiSpanAccumulator =
    { spanCount         :: !Int
    , perSpanGammaWkm   :: !Real
    , perSpanLengthKm   :: !Real
    , launchPowerMw     :: !Real
    }

computeTotalNonlinearPhase :: !MultiSpanAccumulator -> Real
