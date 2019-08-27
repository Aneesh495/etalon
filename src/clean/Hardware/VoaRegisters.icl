
implementation module Etalon.Hardware.VoaRegisters

import StdEnv
import Etalon.Hardware.VoaRegisters
import Etalon.Types.Base

setVoaAttenuationDb :: !Int !Real -> Bool
setVoaAttenuationDb voaId targetAttDb =
    targetAttDb >= 0.0 && targetAttDb <= 30.0
