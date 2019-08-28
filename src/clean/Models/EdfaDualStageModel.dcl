
definition module Etalon.Models.EdfaDualStageModel

import StdEnv
import Etalon.Types.Base

:: DualStageEdfa = {
    stage1GainDb     :: !Real,
    stage2GainDb     :: !Real,
    midStageLossDb   :: !Real,          // DCF or DGE insertion loss (e.g. 6.0 dB)
    stage1NoiseFigDb :: !Real,
    stage2NoiseFigDb :: !Real
}

computeTotalGainDb  :: !DualStageEdfa -> Real
computeCompositeNfDb:: !DualStageEdfa -> Real
