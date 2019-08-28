implementation module Etalon.Simulation.MonteCarloPhysical

/*
 * MonteCarloPhysical.icl: Monte Carlo simulation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Simulation.MonteCarloPhysical
import Etalon.Types.Base

runMonteCarloTrials :: !Int !Real !Real -> [MonteCarloTrial]
runMonteCarloTrials numTrials meanOsnr thresholdOsnr =
    [makeTrial i meanOsnr thresholdOsnr \ i <- [1..numTrials]]
where
    makeTrial :: !Int !Real !Real -> MonteCarloTrial
    makeTrial i mean thresh =
        let variation = sin (toReal i * 0.73) * 1.5
            val = mean + variation
        in { trialId = i, measuredOsnrDb = val, isOutage = val < thresh }

computeOutageRate :: ![MonteCarloTrial] -> Real
computeOutageRate trials =
    let outageCount = sum [if t.isOutage 1 0 \ t <- trials]
    in toReal outageCount / maxReal (toReal (length trials)) 1.0
