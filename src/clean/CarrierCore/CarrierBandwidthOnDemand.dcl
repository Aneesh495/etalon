definition module Etalon.CarrierCore.CarrierBandwidthOnDemand

/*
 * CarrierBandwidthOnDemand.dcl: Optical bandwidth-on-demand dynamic lease scheduler.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: BandwidthReservation =
    { reservationId  :: !Int
    , requestedGbps  :: !Real
    , durationHours  :: !Real
    , isScheduled    :: !Bool
    }

createReservation :: !Int !Real !Real -> BandwidthReservation
activateReservation :: !BandwidthReservation -> BandwidthReservation
