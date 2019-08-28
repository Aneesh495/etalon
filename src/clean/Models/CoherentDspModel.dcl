
definition module Etalon.Models.CoherentDspModel

import StdEnv
import Etalon.Types.Base

:: DspAlgorithmConfig = {
    cmaTapsCount        :: !Int,
    cprBlockSize        :: !Int,
    frequencyOffsetHz   :: !Real,
    residualDispersionPs:: !Real
}

evaluateDspResidualPenaltyDb :: !DspAlgorithmConfig -> Real
