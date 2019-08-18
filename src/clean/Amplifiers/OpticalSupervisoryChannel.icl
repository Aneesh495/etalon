implementation module Etalon.Amplifiers.OpticalSupervisoryChannel

/*
 * OpticalSupervisoryChannel.icl: OSC telemetry implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Amplifiers.OpticalSupervisoryChannel

createOscFrame :: !OscWavelength !Int !Real !Real !Real !Bool !Int -> OscTelemetryFrame
createOscFrame wl spanIn pin pout iLaser cut seq =
    { oscWavelength    = wl
    , spanId           = spanIn
    , ingressPowerDbm  = pin
    , egressPowerDbm   = pout
    , pumpLaserCurrentMa = iLaser
    , fiberCutDetected = cut
    , telemetrySeqNo   = seq
    }

detectOscLossOfSignal :: !OscTelemetryFrame !Real -> Bool
detectOscLossOfSignal frame thresholdDbm =
    frame.ingressPowerDbm < thresholdDbm || frame.fiberCutDetected
