implementation module Etalon.CarrierSla.FiveNinesAvailabilityModel

/*
 * FiveNinesAvailabilityModel.icl: Availability evaluation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierSla.FiveNinesAvailabilityModel

evaluateServiceAvailability :: !AvailabilityTier !Real !Real -> ServiceAvailability
evaluateServiceAvailability tier mttfHours mttrHours =
    let avail = mttfHours / (mttfHours + mttrHours)
        (target, allowedDowntime) = case tier of
            FourNines -> (0.9999, 3153.6)
            FiveNines -> (0.99999, 315.36)
            SixNines  -> (0.999999, 31.536)
        complies = avail >= target
    in { tier                   = tier
       , targetAvailability     = target
       , allowedDowntimeSecsPerYear = allowedDowntime
       , calculatedAvailability = avail
       , compliesWithSla        = complies
       }
