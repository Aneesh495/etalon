
definition module Etalon.Hardware.OpticalSwitchRegisters

import StdEnv
import Etalon.Types.Base

:: SwitchPosition =
    SwitchBar                          // Input 1 to Output 1
  | SwitchCross                        // Input 1 to Output 2

latchOpticalSwitch :: !Int !SwitchPosition -> Bool
