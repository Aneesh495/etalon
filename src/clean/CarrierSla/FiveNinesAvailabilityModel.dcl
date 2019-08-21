definition module Etalon.CarrierSla.FiveNinesAvailabilityModel

/*
 * FiveNinesAvailabilityModel.dcl: Carrier five-nines (99.999%) availability Markov model.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: AvailabilityTier = FiveNines | FourNines | SixNines

:: ServiceAvailability =
    { tier                :: !AvailabilityTier
    , targetAvailability  :: !Real
    , allowedDowntimeSecsPerYear :: !Real
    , calculatedAvailability :: !Real
    , compliesWithSla     :: !Bool
    }

evaluateServiceAvailability :: !AvailabilityTier !Real !Real -> ServiceAvailability
