
implementation module Etalon.Models.PolarizationScramblerModel

import StdEnv
import Etalon.Models.PolarizationScramblerModel
import Etalon.Types.Base

defaultScrambler :: PolarizationScrambler
defaultScrambler = {
    mode               = ScramblerAsynchronous 150.0,
    insertionLossDb    = 2.5,
    residualApmPercent = 0.5
 }
