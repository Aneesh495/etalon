implementation module Etalon.ProtectionSurv.FastOpticalProtectionRing10Ms

/*
 * FastOpticalProtectionRing10Ms.icl: Sub-10ms fast protection implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.ProtectionSurv.FastOpticalProtectionRing10Ms

evaluateFastProtectionSwitch :: !Real !Real -> FastProtectionSwitch
evaluateFastProtectionSwitch detectMs switchMs =
    let total = detectMs + switchMs
        meets = total <= 10.0
    in { switchTimeMs        = switchMs
       , detectionTimeMs     = detectMs
       , totalFailoverMs     = total
       , meetsCarrier10MsSla = meets
       }
