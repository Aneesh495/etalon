
implementation module Etalon.Telemetry.LaserAgingEstimator

import StdEnv
import Etalon.Telemetry.LaserAgingEstimator
import Etalon.Types.Base

estimateLaserRemainingLife :: !Int !Real !Real -> LaserAgingHealth
estimateLaserRemainingLife lId hours currentBiasMa =
    let initialBiasMa = 50.0
        increase = ((currentBiasMa - initialBiasMa) / initialBiasMa) * 100.0
        // End of life typically defined at 50% bias current increase (100,000 hours typical)
        remainingHours = maxReal 0.0 (100000.0 - hours)
        years = remainingHours / 8760.0
    in {
        laserId                     = lId,
        operatingHours              = hours,
        biasCurrentIncreasePercent  = increase,
        estimatedYearsRemaining     = years
    }
