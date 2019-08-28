
implementation module Etalon.Simulation.CloudHyperscaleTrace

import StdEnv
import Etalon.Simulation.CloudHyperscaleTrace
import Etalon.Types.Base

generateHyperscaleFlows :: !Int -> [ServiceDemand]
generateHyperscaleFlows numFlows =
    [makeFlow i \ i <- [1..numFlows]]
where
    makeFlow i =
        let isElephant = (i rem 10) == 0
            bw = if isElephant 800.0 100.0
        in {
            demandId           = i,
            ingressNodeId      = (i rem 16) + 1,
            egressNodeId       = ((i + 7) rem 16) + 1,
            requestedBitrateGbps = bw,
            requiredOsnrDb     = 15.0,
            maxLatencyMs       = 20.0,
            requiresProtection = isElephant,
            preferredModulation= ?None,
            preferredFec       = FecStandardRS
        }
