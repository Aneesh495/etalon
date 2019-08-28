
implementation module Etalon.Telemetry.OsnrDriftDetector

import StdEnv
import Etalon.Telemetry.OsnrDriftDetector
import Etalon.Types.Base

evaluateOsnrDrift :: !Real !Real !Real -> DriftStatus
evaluateOsnrDrift baselineOsnr measuredOsnr thresholdDrop =
    let drop = baselineOsnr - measuredOsnr
    in if (drop >= thresholdDrop * 2.0) (DriftCritical drop)
       (if (drop >= thresholdDrop) (DriftWarning drop) DriftNormal)
