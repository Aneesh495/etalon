definition module Etalon.Optimization.GeneticAlgorithm

/*
 * GeneticAlgorithm.dcl: Evolutionary chromosome spectrum packing.
 *
 * Encodes lightpath route and spectrum assignments as chromosomes:
 *   - Fitness function: inverse of total spectrum utilization and blocking probability
 *   - Two-point crossover preserving lightpath routing continuity
 *   - Bit-flip mutation for alternate k-shortest paths and first-fit retuning
 *   - Elitism preserving top 10% fittest network configurations
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.NetworkState

:: Gene = {
    demandId   :: !Int,
    routeIndex :: !Int,        // Index in K-shortest paths list
    slotIndex  :: !Int         // Start slice index
}

:: Chromosome = {
    genes      :: ![Gene],
    fitness    :: !Real,
    isValid    :: !Bool
}

:: GaConfig = {
    populationSize   :: !Int,
    numGenerations   :: !Int,
    crossoverRate    :: !Real,
    mutationRate     :: !Real,
    eliteFraction    :: !Real
}

defaultGaConfig      :: GaConfig
evaluateFitness      :: !Chromosome !WorldState -> Real
crossoverChromosomes :: !Chromosome !Chromosome !Int -> (!Chromosome, !Chromosome)
mutateChromosome     :: !Chromosome !Real !Int -> Chromosome
runGeneticOptimizer  :: !*WorldState ![ServiceDemand] !GaConfig -> (*WorldState, Chromosome)
