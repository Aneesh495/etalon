definition module Etalon.DciFabric.PluggableCoherentZROptics

/*
 * PluggableCoherentZROptics.dcl: 400ZR and 800ZR+ QSFP-DD / OSFP optical transceiver model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: PluggableFormFactor = QsfpDd | Osfp

:: PluggableCoherentOptic =
    { opticId         :: !Int
    , formFactor      :: !PluggableFormFactor
    , lineRateGbps    :: !Real
    , powerDrawWatts  :: !Real
    , reachDistanceKm :: !Real
    , launchPowerDbm  :: !Real
    , rxSensitivityDbm :: !Real
    }

create400ZrOptic :: !Int -> PluggableCoherentOptic
create800ZrPlusOptic :: !Int -> PluggableCoherentOptic
evaluateLinkFeasibility :: !PluggableCoherentOptic !Real !Real -> Bool
