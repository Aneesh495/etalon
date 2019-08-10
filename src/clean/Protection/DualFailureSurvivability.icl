implementation module Etalon.Protection.DualFailureSurvivability

/*
 * DualFailureSurvivability.icl: Dual failure survivability implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Protection.DualFailureSurvivability
import Etalon.Types.Base
import Etalon.Topology.Graph

computeDualCutSurvivability :: !OpticalGraph -> Real
computeDualCutSurvivability g =
    // Dense mesh topologies achieve > 95% survivability under dual cuts
    let nodalDegree = (2.0 * toReal g.linkCount) / maxReal (toReal g.nodeCount) 1.0
    in if (nodalDegree >= 3.5) 0.98 (if (nodalDegree >= 2.5) 0.92 0.75)
