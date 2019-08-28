
definition module Etalon.Telemetry.LaserAgingEstimator

import StdEnv
import Etalon.Types.Base

:: LaserAgingHealth = {
    laserId          :: !Int,
    operatingHours   :: !Real,
    biasCurrentIncreasePercent:: !Real,
    estimatedYearsRemaining:: !Real
}

estimateLaserRemainingLife :: !Int !Real !Real -> LaserAgingHealth
