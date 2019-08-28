implementation module Etalon.Simulation.CarrierDemandTraces

/*
 * CarrierDemandTraces.icl: Demand traces implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Simulation.CarrierDemandTraces
import Etalon.Types.Base

generateCarrierWorkload :: !Int !Int -> [ServiceDemand]
generateCarrierWorkload numDemands numNodes =
    [makeDemand i numNodes \ i <- [1..numDemands]]
where
    makeDemand :: !Int !Int -> ServiceDemand
    makeDemand idx nNodes =
        let src = ((idx * 7) rem nNodes) + 1
            dstCandidate = ((idx * 13) rem nNodes) + 1
            dst = if (src == dstCandidate) ((src rem nNodes) + 1) dstCandidate
            rate = case idx rem 4 of
                0 -> 100.0
                1 -> 200.0
                2 -> 400.0
                _ -> 800.0
            needProt = (idx rem 2) == 0
        in {
            demandId           = idx,
            ingressNodeId      = src,
            egressNodeId       = dst,
            requestedBitrateGbps = rate,
            requiredOsnrDb     = 14.5,
            maxLatencyMs       = 45.0,
            requiresProtection = needProt,
            preferredModulation= ?None,
            preferredFec       = FecStandardRS
        }
