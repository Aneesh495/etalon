implementation module Etalon.DciFabric.PluggableCoherentZROptics

/*
 * PluggableCoherentZROptics.icl: 400ZR/800ZR pluggable optics implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.DciFabric.PluggableCoherentZROptics

create400ZrOptic :: !Int -> PluggableCoherentOptic
create400ZrOptic id =
    { opticId          = id
    , formFactor       = QsfpDd
    , lineRateGbps     = 400.0
    , powerDrawWatts   = 16.5
    , reachDistanceKm  = 120.0
    , launchPowerDbm   = -10.0
    , rxSensitivityDbm = -20.0
    }

create800ZrPlusOptic :: !Int -> PluggableCoherentOptic
create800ZrPlusOptic id =
    { opticId          = id
    , formFactor       = Osfp
    , lineRateGbps     = 800.0
    , powerDrawWatts   = 24.0
    , reachDistanceKm  = 450.0
    , launchPowerDbm   = 0.0
    , rxSensitivityDbm = -22.0
    }

evaluateLinkFeasibility :: !PluggableCoherentOptic !Real !Real -> Bool
evaluateLinkFeasibility optic fiberLengthKm spanLossDb =
    let linkLoss = spanLossDb + (fiberLengthKm * 0.22)
        powerMargin = optic.launchPowerDbm - optic.rxSensitivityDbm - linkLoss
    in fiberLengthKm <= optic.reachDistanceKm && powerMargin >= 2.0
