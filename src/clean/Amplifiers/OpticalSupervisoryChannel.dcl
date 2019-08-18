definition module Etalon.Amplifiers.OpticalSupervisoryChannel

/*
 * OpticalSupervisoryChannel.dcl: Out-of-band Optical Supervisory Channel (OSC) engine.
 * Supports 1510 nm and 1610 nm telemetry framers for remote link diagnostics.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: OscWavelength = Osc1510Nm | Osc1610Nm

:: OscTelemetryFrame =
    { oscWavelength    :: !OscWavelength
    , spanId           :: !Int
    , ingressPowerDbm  :: !Real
    , egressPowerDbm   :: !Real
    , pumpLaserCurrentMa :: !Real
    , fiberCutDetected :: !Bool
    , telemetrySeqNo   :: !Int
    }

createOscFrame :: !OscWavelength !Int !Real !Real !Real !Bool !Int -> OscTelemetryFrame
detectOscLossOfSignal :: !OscTelemetryFrame !Real -> Bool
