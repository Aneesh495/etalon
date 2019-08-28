definition module Etalon.Simulation.CarrierChurnTraffic

/*
 * CarrierChurnTraffic.dcl: Diurnal carrier traffic fluctuation model.
 *
 * Generates realistic day/night traffic churn curves:
 *   - Peak load during business hours (14:00 to 20:00 UTC)
 *   - Trough load during early morning (02:00 to 06:00 UTC)
 *   - Weibull distributed service connection durations
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

computeDiurnalLoadFactor:: !Real -> Real
