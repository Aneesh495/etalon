implementation module Etalon.CarrierCore.PolarizationScrambler

/*
 * PolarizationScrambler.icl: Polarization scrambler implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.PolarizationScrambler

createScrambler :: !ScramblerMode !Real -> PolarizationScramblerSpec
createScrambler m rate =
    let dop = if (rate > 500.0) 0.05 0.15
    in { mode              = m
       , scramblingRateKhz = rate
       , residualDop       = dop
       }

isScramblerEffective :: !PolarizationScramblerSpec -> Bool
isScramblerEffective spec =
    spec.residualDop <= 0.10
