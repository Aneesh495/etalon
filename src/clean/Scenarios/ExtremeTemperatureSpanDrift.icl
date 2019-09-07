
implementation module Etalon.Scenarios.ExtremeTemperatureSpanDrift

import StdEnv
import Etalon.Scenarios.ExtremeTemperatureSpanDrift
import Etalon.Telemetry.LaserAgingEstimator

runTemperatureDriftSimulation :: Bool
runTemperatureDriftSimulation =
    let h = estimateLaserRemainingLife 1 10000.0 52.0
    in h.estimatedYearsRemaining > 0.0
