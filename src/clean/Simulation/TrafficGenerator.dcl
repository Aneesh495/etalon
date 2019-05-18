definition module Etalon.Simulation.TrafficGenerator

/*
 * TrafficGenerator.dcl: Stochastic Traffic and Connection Request Generation.
 *
 * Implements Poisson arrival processes and exponential holding times for dynamic
 * optical service connection requests (10GbE, 100GbE, 400GbE, 800GbE).
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Routing.ImpairmentAware

:: TrafficProfile = {
    arrivalRateLambda  :: !Real,          // Poisson arrival rate (requests / hour)
    meanHoldingTimeHours :: !Real,        // Exponential holding duration
    bitrateDistribution :: ![(Real, Real)], // Pairs of (bitrateGbps, probabilityWeight)
    protectionRatio    :: !Real           // Fraction of demands requesting 1+1 protection
}

:: DynamicConnectionEvent =
    EventArrival !ServiceDemand !Real     // Demand and arrival time (seconds)
  | EventDeparture !Int !Real             // Demand ID and teardown time (seconds)

// Pseudorandom number generator state (LCG)
:: *PrngState = {
    seed               :: !Int
}

// PRNG primitives
initPrng               :: !Int -> *PrngState
nextUniformReal        :: !*PrngState -> (*PrngState, Real)
nextExponentialReal    :: !*PrngState !Real -> (*PrngState, Real)

// Traffic generation
generateDemandsSequence :: !*PrngState !TrafficProfile !Int !Int !Int -> (*PrngState, [ServiceDemand])
createDefaultMetroProfile :: -> TrafficProfile
createDefaultLongHaulProfile :: -> TrafficProfile
