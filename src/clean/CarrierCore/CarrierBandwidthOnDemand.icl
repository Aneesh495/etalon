implementation module Etalon.CarrierCore.CarrierBandwidthOnDemand

/*
 * CarrierBandwidthOnDemand.icl: Bandwidth-on-demand implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierCore.CarrierBandwidthOnDemand

createReservation :: !Int !Real !Real -> BandwidthReservation
createReservation id bw dur =
    { reservationId = id
    , requestedGbps = bw
    , durationHours = dur
    , isScheduled   = False
    }

activateReservation :: !BandwidthReservation -> BandwidthReservation
activateReservation res =
    { res & isScheduled = True }
