
definition module Etalon.Hardware.TransponderRegisters

import StdEnv
import Etalon.Types.Base

:: CmisRegisterMap = {
    moduleState        :: !Int,         // 0x01 = LowPower, 0x02 = Ready
    rxPowerDbm         :: !Real,        // Page 0x11 Byte 186-187
    txPowerDbm         :: !Real,        // Page 0x11 Byte 154-155
    txBiasCurrentMa    :: !Real,        // Page 0x11 Byte 170-171
    caseTemperatureC   :: !Real         // Page 0x00 Byte 14-15
}

readTransponderTelemetry :: !Int -> CmisRegisterMap
