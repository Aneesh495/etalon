definition module Etalon.Simulation.CarrierDemandTraces

/*
 * CarrierDemandTraces.dcl: Pre-canned carrier demand traces for benchmarking.
 *
 * Generates deterministic workloads matching Tier-1 carrier traffic matrices:
 *   - 100G, 200G, 400G, and 800G optical connection requests
 *   - Variable SLA protection tiers and max latency bounds
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

generateCarrierWorkload :: !Int !Int -> [ServiceDemand]
