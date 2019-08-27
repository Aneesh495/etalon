
implementation module Etalon.Hardware.WssRegisters

import StdEnv
import Etalon.Hardware.WssRegisters
import Etalon.Types.Base

executeWssPortSwitch :: !Int !Int !Int -> WssCommandStatus
executeWssPortSwitch wssId inPort outPort =
    if (inPort > 0 && outPort > 0) WssSuccess WssInvalidPort
