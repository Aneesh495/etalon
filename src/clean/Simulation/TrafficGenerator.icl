implementation module Etalon.Simulation.TrafficGenerator

/*
 * TrafficGenerator.icl: Implementation of Poisson and exponential traffic generation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Routing.ImpairmentAware
import Etalon.Simulation.TrafficGenerator

createDefaultMetroProfile :: -> TrafficProfile
createDefaultMetroProfile = {
    arrivalRateLambda    = 120.0, // 120 arrivals / hour
    meanHoldingTimeHours = 2.0,   // 2 hours mean holding time
    bitrateDistribution  = [(100.0, 0.60), (400.0, 0.35), (800.0, 0.05)],
    protectionRatio      = 0.50   // 50% protected
}

createDefaultLongHaulProfile :: -> TrafficProfile
createDefaultLongHaulProfile = {
    arrivalRateLambda    = 40.0,
    meanHoldingTimeHours = 12.0,
    bitrateDistribution  = [(100.0, 0.30), (400.0, 0.50), (800.0, 0.20)],
    protectionRatio      = 0.80   // 80% protected
}

initPrng :: !Int -> *PrngState
initPrng s = { seed = if (s == 0) 123456789 s }

nextUniformReal :: !*PrngState -> (*PrngState, Real)
nextUniformReal state=:{seed} =
    // Linear Congruential Generator: a = 1664525, c = 1013904223, m = 2^31
    let nextSeed = ((seed * 1664525) + 1013904223) bitand 0x7FFFFFFF
        u = (toReal nextSeed) / 2147483647.0
    in ({ state & seed = nextSeed }, u)

nextExponentialReal :: !*PrngState !Real -> (*PrngState, Real)
nextExponentialReal state meanVal =
    let (s1, u) = nextUniformReal state
        safeU = if (u <= 1.0e-7) 1.0e-7 u
        expVal = ~ (meanVal * (ln safeU))
    in (s1, expVal)

generateDemandsSequence :: !*PrngState !TrafficProfile !Int !Int !Int -> (*PrngState, [ServiceDemand])
generateDemandsSequence prng profile nodeCount totalDemands startId =
    generate prng 1 []
where
    generate :: !*PrngState !Int ![ServiceDemand] -> (*PrngState, [ServiceDemand])
    generate curPrng count acc
        | count > totalDemands = (curPrng, reverse acc)
        = let (s1, uSrc) = nextUniformReal curPrng
              (s2, uDst) = nextUniformReal s1
              (s3, uBw) = nextUniformReal s2
              (s4, uProt) = nextUniformReal s3
              src = 1 + (toInt (uSrc * (toReal nodeCount)))
              rawDst = 1 + (toInt (uDst * (toReal nodeCount)))
              dst = if (rawDst == src) ((src rem nodeCount) + 1) rawDst
              bitrate = pickBitrate uBw profile.bitrateDistribution 100.0
              isProtected = uProt < profile.protectionRatio
              demand = {
                  demandId             = startId + count - 1,
                  ingressNodeId        = src,
                  egressNodeId         = dst,
                  requestedBitrateGbps = bitrate,
                  preferredFec         = FecHd7Percent,
                  requireProtection    = isProtected
              }
          in generate s4 (count + 1) [demand : acc]

    pickBitrate :: !Real ![(Real, Real)] !Real -> Real
    pickBitrate _ [] fallback = fallback
    pickBitrate u [(bw, weight):rest] fallback
        | u <= weight = bw
        = pickBitrate (u - weight) rest bw
