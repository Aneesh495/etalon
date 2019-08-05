definition module Etalon.Otn.OtnDelayMeasurement

/*
 * OtnDelayMeasurement.dcl: ODU delay measurement (DMp/DMo) timestamp processing per ITU-T G.709.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: DelayMeasurementRecord =
    { txTimestampPs :: !Real
    , rxTimestampPs :: !Real
    , roundTripPs   :: !Real
    , oneWayPs      :: !Real
    , fiberDistanceKm :: !Real
    }

computeDelayRecord :: !Real !Real -> DelayMeasurementRecord
validateLatencySla :: !DelayMeasurementRecord !Real -> Bool
