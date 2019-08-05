implementation module Etalon.Otn.OtnDelayMeasurement

/*
 * OtnDelayMeasurement.icl: Delay measurement implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.OtnDelayMeasurement

computeDelayRecord :: !Real !Real -> DelayMeasurementRecord
computeDelayRecord txPs rxPs =
    let rtt = rxPs - txPs
        oneWay = rtt / 2.0
        km = (oneWay * 1.0e-12) * (299792.458 / 1.4682)
    in { txTimestampPs   = txPs
       , rxTimestampPs   = rxPs
       , roundTripPs     = rtt
       , oneWayPs        = oneWay
       , fiberDistanceKm = km
       }

validateLatencySla :: !DelayMeasurementRecord !Real -> Bool
validateLatencySla record maxAllowedOneWayPs =
    record.oneWayPs <= maxAllowedOneWayPs
