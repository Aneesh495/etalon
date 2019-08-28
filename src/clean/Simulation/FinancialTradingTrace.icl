
implementation module Etalon.Simulation.FinancialTradingTrace

import StdEnv
import Etalon.Simulation.FinancialTradingTrace
import Etalon.Types.Base

generateFinancialDemands :: !Int -> [ServiceDemand]
generateFinancialDemands n =
    [makeFin i \ i <- [1..n]]
where
    makeFin i = {
        demandId           = i,
        ingressNodeId      = 1, // e.g. NY4 Secaucus
        egressNodeId       = 2, // e.g. CME Aurora
        requestedBitrateGbps = 100.0,
        requiredOsnrDb     = 16.0,
        maxLatencyMs       = 14.5, // strict SLA
        requiresProtection = True,
        preferredModulation= ?None,
        preferredFec       = FecStandardRS
    }
