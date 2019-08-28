definition module Etalon.Simulation.ErlangTrafficEngine

/*
 * ErlangTrafficEngine.dcl: Erlang-B and Erlang-C blocking probability models.
 *
 * Computes exact Erlang loss and delay formulas for optical trunk groups:
 *   - Erlang-B: B(E, C) = (E^C / C!) / Sum_{k=0}^C (E^k / k!)
 *   - Erlang-C: Delay probability in queued requests
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

computeErlangB         :: !Real !Int -> Real
computeErlangC         :: !Real !Int -> Real
