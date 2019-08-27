
definition module Etalon.Hardware.EdfaControllerRegisters

import StdEnv
import Etalon.Types.Base

:: EdfaControlMode =
    ModeConstantGain !Real             // Target gain in dB
  | ModeConstantPower !Real            // Target output power in dBm
  | ModeConstantCurrent !Real          // Pump laser current in mA

setEdfaMode :: !Int !EdfaControlMode -> Bool
