
implementation module Etalon.Telemetry.FiberDegradationPredictor

import StdEnv
import Etalon.Telemetry.FiberDegradationPredictor
import Etalon.Types.Base

findAttenuationHotspots :: ![(!Real, !Real)] !Real -> [Real]
findAttenuationHotspots otdrTraces thresholdLossDb =
    // Identifies kilometer marks where localized step loss exceeds threshold
    [km \ (km, stepLoss) <- otdrTraces | stepLoss >= thresholdLossDb]
