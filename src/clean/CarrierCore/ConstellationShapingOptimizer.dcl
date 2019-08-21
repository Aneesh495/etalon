definition module Etalon.CarrierCore.ConstellationShapingOptimizer

/*
 * ConstellationShapingOptimizer.dcl: Probabilistic Constellation Shaping (PCS) entropy calculator.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: PcsConfig =
    { constellationBaseQam :: !Int
    , shapingParameterNu   :: !Real
    , targetEntropyBits    :: !Real
    }

:: PcsResult =
    { informationalEntropyBits :: !Real
    , shapingGainDb            :: !Real
    , reachMultiplier          :: !Real
    }

evaluatePcsConfig :: !PcsConfig -> PcsResult
