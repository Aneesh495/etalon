
implementation module Etalon.Simulation.SubseaDisasterTrace

import StdEnv
import Etalon.Simulation.SubseaDisasterTrace
import Etalon.Types.Base

generateDiversionDemands :: !Int -> [ServiceDemand]
generateDiversionDemands n =
    [makeDiv i \ i <- [1..n]]
where
    makeDiv i = {
        demandId           = i,
        ingressNodeId      = 1,
        egressNodeId       = 3,
        requestedBitrateGbps = 400.0,
        requiredOsnrDb     = 14.0,
        maxLatencyMs       = 120.0,
        requiresProtection = True,
        preferredModulation= ?None,
        preferredFec       = FecStandardRS
    }
