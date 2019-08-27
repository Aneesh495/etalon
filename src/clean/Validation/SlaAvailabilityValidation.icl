
implementation module Etalon.Validation.SlaAvailabilityValidation

import StdEnv
import Etalon.Validation.SlaAvailabilityValidation
import Etalon.Simulation.SlaManager

validateFiveNinesCompliance :: !SlaRecord -> Bool
validateFiveNinesCompliance rec =
    let avail = computeMeasuredAvailability rec
    in avail >= 99.999
