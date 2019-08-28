
definition module Etalon.Models.PolarizationScramblerModel

import StdEnv
import Etalon.Types.Base

:: ScramblerMode =
    ScramblerSynchronous
  | ScramblerAsynchronous !Real         // Rotation rate in krad/s

:: PolarizationScrambler = {
    mode             :: !ScramblerMode,
    insertionLossDb  :: !Real,
    residualApmPercent:: !Real
}

defaultScrambler :: PolarizationScrambler
