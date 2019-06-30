definition module Etalon.Optimization.SimulatedAnnealing

/*
 * SimulatedAnnealing.dcl: Metropolis-Hastings spectral defragmentation.
 *
 * Implements simulated annealing for optical spectrum defragmentation:
 *   - Energy function: weighted sum of spectrum fragmentation index,
 *     maximum allocated slice index, and optical cross-talk penalties.
 *   - Perturbation operators: lightpath frequency shifting and rerouting.
 *   - Temperature schedule: T(k) = T0 * alpha^k with reheat triggers.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.NetworkState
import Etalon.Topology.Path

:: SaConfig = {
    initialTemperature:: !Real,        // T0 (e.g., 1000.0)
    coolingRate       :: !Real,        // alpha (e.g., 0.98)
    iterationsPerTemp :: !Int,         // Markov chain length (e.g., 50)
    minTemperature    :: !Real,        // Stopping criterion (e.g., 0.01)
    reheatThreshold   :: !Int          // Stagnation steps before reheating
}

:: SaResult = {
    finalEnergy       :: !Real,
    energyHistory     :: ![Real],
    totalIterations   :: !Int,
    acceptedMoves     :: !Int,
    reheatCount       :: !Int,
    improvedSolution  :: !Bool
}

defaultSaConfig       :: SaConfig
evaluateSpectrumEnergy:: !WorldState -> Real
evaluateSpectrumEnergyWith:: ![LinkSpectrumState] ![Lightpath] -> Real
perturbAllocation     :: !WorldState !Int -> WorldState
runSimulatedAnnealing :: !*WorldState !SaConfig -> (*WorldState, SaResult)
