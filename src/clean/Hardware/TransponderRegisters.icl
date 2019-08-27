
implementation module Etalon.Hardware.TransponderRegisters

import StdEnv
import Etalon.Hardware.TransponderRegisters
import Etalon.Types.Base

readTransponderTelemetry :: !Int -> CmisRegisterMap
readTransponderTelemetry portId = {
    moduleState      = 2, // ModuleReady
    rxPowerDbm       = ~8.5,
    txPowerDbm       = 0.5,
    txBiasCurrentMa  = 65.2,
    caseTemperatureC = 42.5
 }
