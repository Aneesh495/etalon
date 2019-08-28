
definition module Etalon.Monitoring.DailyHistoryBins

import StdEnv
import Etalon.Types.Base

:: DailyHistoryBin = {
    dayIndex           :: !Int,
    totalErroredSeconds:: !Int,
    totalUas           :: !Int
}

createDailyBin :: !Int -> DailyHistoryBin
