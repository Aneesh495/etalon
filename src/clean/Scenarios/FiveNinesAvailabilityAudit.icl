
implementation module Etalon.Scenarios.FiveNinesAvailabilityAudit

import StdEnv
import Etalon.Scenarios.FiveNinesAvailabilityAudit
import Etalon.Simulation.SlaManager

runFiveNinesAuditSimulation :: Bool
runFiveNinesAuditSimulation =
    let rec = { serviceId = 1, targetAvailabilityPercent = 99.999, totalUptimeSeconds = 31536000.0, totalDowntimeSeconds = 250.0 }
    in isSlaCompliant rec
