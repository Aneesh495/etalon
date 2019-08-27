
definition module Etalon.Hardware.WssRegisters

import StdEnv
import Etalon.Types.Base

:: WssCommandStatus =
    WssSuccess
  | WssHardwareBusy
  | WssInvalidPort

executeWssPortSwitch :: !Int !Int !Int -> WssCommandStatus
