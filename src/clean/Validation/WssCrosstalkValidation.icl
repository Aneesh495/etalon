
implementation module Etalon.Validation.WssCrosstalkValidation

import StdEnv
import Etalon.Validation.WssCrosstalkValidation
import Etalon.Physical.WavelengthSelectiveSwitch

validatePortIsolation :: !Real -> Bool
validatePortIsolation isolationDb =
    isolationDb <= ~40.0 // at least 40 dB isolation
