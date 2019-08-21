definition module Etalon.ProtectionSurv.FastOpticalProtectionRing10Ms

/*
 * FastOpticalProtectionRing10Ms.dcl: Sub-10ms optical protection engine using magneto-optic switches.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: FastProtectionSwitch =
    { switchTimeMs     :: !Real
    , detectionTimeMs  :: !Real
    , totalFailoverMs  :: !Real
    , meetsCarrier10MsSla :: !Bool
    }

evaluateFastProtectionSwitch :: !Real !Real -> FastProtectionSwitch
