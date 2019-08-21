implementation module Etalon.CarrierCore.ConstellationShapingOptimizer

/*
 * ConstellationShapingOptimizer.icl: PCS optimization implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.ConstellationShapingOptimizer

evaluatePcsConfig :: !PcsConfig -> PcsResult
evaluatePcsConfig cfg =
    let entropy = cfg.targetEntropyBits
        shapingGain = if (entropy < 5.5) 1.25 0.65
        multiplier = 1.0 + (shapingGain * 0.25)
    in { informationalEntropyBits = entropy
       , shapingGainDb            = shapingGain
       , reachMultiplier          = multiplier
       }
