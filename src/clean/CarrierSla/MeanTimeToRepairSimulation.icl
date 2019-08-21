implementation module Etalon.CarrierSla.MeanTimeToRepairSimulation

/*
 * MeanTimeToRepairSimulation.icl: MTTR evaluation implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.CarrierSla.MeanTimeToRepairSimulation

calculateMttrHours :: !DispatchProfile -> Real
calculateMttrHours p =
    p.travelTimeHours + p.spliceTimeHours + p.testTimeHours

evaluateDispatchCompliance :: !DispatchProfile !Real -> Bool
evaluateDispatchCompliance p maxSlaHours =
    (calculateMttrHours p) <= maxSlaHours
