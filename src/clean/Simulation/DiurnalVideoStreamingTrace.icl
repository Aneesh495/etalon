
implementation module Etalon.Simulation.DiurnalVideoStreamingTrace

import StdEnv
import Etalon.Simulation.DiurnalVideoStreamingTrace
import Etalon.Types.Base

generateStreamingDemands :: !Int !Real -> [ServiceDemand]
generateStreamingDemands count hourUtc =
    let peakMultiplier = if (hourUtc >= 18.0 && hourUtc <= 22.0) 2.5 1.0
    in [makeDemand i peakMultiplier \ i <- [1..count]]
where
    makeDemand i mult = {
        demandId           = i,
        ingressNodeId      = (i rem 8) + 1,
        egressNodeId       = ((i + 3) rem 8) + 1,
        requestedBitrateGbps = 100.0 * mult,
        requiredOsnrDb     = 14.0,
        maxLatencyMs       = 50.0,
        requiresProtection = False,
        preferredModulation= ?None,
        preferredFec       = FecStandardRS
    }
