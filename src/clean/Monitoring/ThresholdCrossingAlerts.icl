
implementation module Etalon.Monitoring.ThresholdCrossingAlerts

import StdEnv
import Etalon.Monitoring.ThresholdCrossingAlerts
import Etalon.Types.Base

checkTcaAlert :: !Int !Int -> Bool
checkTcaAlert currentErrors threshold =
    currentErrors >= threshold
