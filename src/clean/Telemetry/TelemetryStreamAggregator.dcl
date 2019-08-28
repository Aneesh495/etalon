
definition module Etalon.Telemetry.TelemetryStreamAggregator

import StdEnv
import Etalon.Types.Base

:: TimeSeriesStats = {
    sampleCount :: !Int,
    meanValue   :: !Real,
    minValue    :: !Real,
    maxValue    :: !Real
}

computeRollingStats :: ![Real] -> TimeSeriesStats
