definition module Etalon.Protection.DualFailureSurvivability

/*
 * DualFailureSurvivability.dcl: Dual fiber cut survivability evaluation.
 *
 * Evaluates probability that a network survives two simultaneous cuts:
 *   - Shared Risk Node Group (SRNG) correlation
 *   - Topology biconnectivity and triconnectivity analysis
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph

computeDualCutSurvivability:: !OpticalGraph -> Real
