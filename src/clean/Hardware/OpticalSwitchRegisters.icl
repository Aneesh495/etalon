
implementation module Etalon.Hardware.OpticalSwitchRegisters

import StdEnv
import Etalon.Hardware.OpticalSwitchRegisters
import Etalon.Types.Base

latchOpticalSwitch :: !Int !SwitchPosition -> Bool
latchOpticalSwitch swId pos =
    True
