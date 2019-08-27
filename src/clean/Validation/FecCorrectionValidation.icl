
implementation module Etalon.Validation.FecCorrectionValidation

import StdEnv
import Etalon.Validation.FecCorrectionValidation

validateFecCorrectionCapacity :: !Int -> Bool
validateFecCorrectionCapacity errorsCount =
    // RS(255, 239) corrects up to t = (255 - 239) / 2 = 8 byte errors per sub-row
    errorsCount <= 8
