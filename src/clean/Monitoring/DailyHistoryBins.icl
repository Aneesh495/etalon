
implementation module Etalon.Monitoring.DailyHistoryBins

import StdEnv
import Etalon.Monitoring.DailyHistoryBins
import Etalon.Types.Base

createDailyBin :: !Int -> DailyHistoryBin
createDailyBin day = {
    dayIndex            = day,
    totalErroredSeconds = 0,
    totalUas            = 0
 }
