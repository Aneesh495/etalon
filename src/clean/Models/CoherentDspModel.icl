
implementation module Etalon.Models.CoherentDspModel

import StdEnv
import Etalon.Models.CoherentDspModel
import Etalon.Types.Base

evaluateDspResidualPenaltyDb :: !DspAlgorithmConfig -> Real
evaluateDspResidualPenaltyDb cfg =
    let cdPenalty = (abs cfg.residualDispersionPs / 1000.0) * 0.05
        foPenalty = (abs cfg.frequencyOffsetHz / 1.0e9) * 0.10
    in cdPenalty + foPenalty
