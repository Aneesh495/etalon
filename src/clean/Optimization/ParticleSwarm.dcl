definition module Etalon.Optimization.ParticleSwarm

/*
 * ParticleSwarm.dcl: Particle Swarm Optimization (PSO) optical power leveling.
 *
 * Balances amplifier launch powers across cascaded spans:
 *   - Particle position: launch powers x_i in C-band channels
 *   - Velocity update: v_i(t+1) = w*v_i(t) + c1*r1*(pbest_i - x_i) + c2*r2*(gbest - x_i)
 *   - Objective: maximize minimum OSNR margin across all optical lightpaths
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: PsoParticle = {
    positionPowersW    :: ![Real],
    velocityPowersW    :: ![Real],
    bestPositionPowersW:: ![Real],
    bestFitness        :: !Real
}

runPsoOptimization    :: !Int !Int -> Real
