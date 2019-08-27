
definition module Etalon.Diagnostics.OpticalEyeDiagramAnalyzer

import StdEnv
import Etalon.Types.Base

:: EyeMetrics = {
    eyeHeightMv     :: !Real,
    eyeWidthPs      :: !Real,
    qFactorLinear   :: !Real,
    jitterRmsPs     :: !Real
}

computeEyeMetrics :: !Real !Real -> EyeMetrics
