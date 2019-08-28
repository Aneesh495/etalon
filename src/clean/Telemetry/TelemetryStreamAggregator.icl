
implementation module Etalon.Telemetry.TelemetryStreamAggregator

import StdEnv
import Etalon.Telemetry.TelemetryStreamAggregator
import Etalon.Types.Base

computeRollingStats :: ![Real] -> TimeSeriesStats
computeRollingStats [] = { sampleCount = 0, meanValue = 0.0, minValue = 0.0, maxValue = 0.0 }
computeRollingStats samples =
    let count = length samples
        sumVal = foldr (+) 0.0 samples
        mean = sumVal / toReal count
        minVal = foldr minReal 1.0e9 samples
        maxVal = foldr maxReal (~1.0e9) samples
    in {
        sampleCount = count,
        meanValue   = mean,
        minValue    = minVal,
        maxValue    = maxVal
    }
