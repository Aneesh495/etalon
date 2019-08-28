
implementation module Etalon.Monitoring.FifteenMinuteBins

import StdEnv
import Etalon.Monitoring.FifteenMinuteBins
import Etalon.Types.Base

createEmptyBin :: !Int -> FifteenMinuteBin
createEmptyBin idx = {
    binIndex           = idx,
    erroredSec         = 0,
    severelyErroredSec = 0,
    unavailableSec     = 0
 }
