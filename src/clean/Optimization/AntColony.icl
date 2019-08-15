implementation module Etalon.Optimization.AntColony

/*
 * AntColony.icl: Ant Colony implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Optimization.AntColony
import Etalon.Types.Base

computeAcsTransitionProb :: !Real !Real !Real !Real -> Real
computeAcsTransitionProb pheromone heuristic alpha beta =
    let term1 = pheromone ^ alpha
        term2 = heuristic ^ beta
    in term1 * term2

updatePheromoneTrail :: !Real !Real !Real -> Real
updatePheromoneTrail currentPheromone deltaPheromone rho =
    (1.0 - rho) * currentPheromone + deltaPheromone
