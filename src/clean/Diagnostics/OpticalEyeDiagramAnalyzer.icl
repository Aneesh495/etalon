
implementation module Etalon.Diagnostics.OpticalEyeDiagramAnalyzer

import StdEnv
import Etalon.Diagnostics.OpticalEyeDiagramAnalyzer
import Etalon.Types.Base

computeEyeMetrics :: !Real !Real -> EyeMetrics
computeEyeMetrics signalMv noiseMv =
    let h = maxReal 0.0 (signalMv - noiseMv * 3.0)
        q = if (noiseMv <= 0.0) 20.0 (signalMv / noiseMv)
    in {
        eyeHeightMv   = h,
        eyeWidthPs    = 25.0,
        qFactorLinear = q,
        jitterRmsPs   = 1.2
    }
