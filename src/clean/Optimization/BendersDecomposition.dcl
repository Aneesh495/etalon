definition module Etalon.Optimization.BendersDecomposition

/*
 * BendersDecomposition.dcl: Benders decomposition for multi-period capacity.
 *
 * Decomposes carrier optical network design into master and subproblems:
 *   - Master Problem: Integer decisions on fiber lease and transponder provisioning
 *   - Subproblem: Dual multi-commodity flow routing under fixed hardware capacity
 *   - Benders feasibility and optimality cuts generation
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: BendersCut = {
    cutIndex     :: !Int,
    isOptimalityCut :: !Bool,
    constantRhs  :: !Real
}

solveMasterIteration :: !Int ![BendersCut] -> Real
