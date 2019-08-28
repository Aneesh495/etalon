
definition module Etalon.Monitoring.FifteenMinuteBins

import StdEnv
import Etalon.Types.Base

:: FifteenMinuteBin = {
    binIndex   :: !Int,         // 0..95 for 24h
    erroredSec :: !Int,
    severelyErroredSec:: !Int,
    unavailableSec:: !Int
}

createEmptyBin :: !Int -> FifteenMinuteBin
