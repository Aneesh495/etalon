implementation module Etalon.Physical.StimulatedBrillouinScattering

/*
 * StimulatedBrillouinScattering.icl: SBS threshold implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.StimulatedBrillouinScattering
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeSbsThresholdPowerW :: !FiberSpan !Real -> Real
computeSbsThresholdPowerW span laserLinewidthHz =
    let aEffM2 = span.fiberType.effectiveAreaUm2 * 1.0e-12
        gB = 5.0e-11 // m/W peak Brillouin gain
        effLengthM = effectiveLengthKm span * 1000.0
        brillouinBwHz = 30.0e6 // 30 MHz
        broadeningFactor = 1.0 + (laserLinewidthHz / brillouinBwHz)
        pTh = (21.0 * aEffM2 / (gB * effLengthM)) * broadeningFactor
    in pTh

isSbsSuppressed :: !Real !Real -> Bool
isSbsSuppressed launchPowerW sbsThresholdW =
    launchPowerW < (sbsThresholdW * 0.8)
