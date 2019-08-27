
implementation module Etalon.Validation.OsnrMarginValidation

import StdEnv
import Etalon.Validation.OsnrMarginValidation
import Etalon.Types.Base

validateOsnrMarginThreshold :: !Real !Real !Real -> Bool
validateOsnrMarginThreshold measuredOsnr reqOsnr requiredMargin =
    (measuredOsnr - reqOsnr) >= requiredMargin
