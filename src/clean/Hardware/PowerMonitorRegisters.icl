
implementation module Etalon.Hardware.PowerMonitorRegisters

import StdEnv
import Etalon.Hardware.PowerMonitorRegisters
import Etalon.Types.Base

readOpmChannelPowerDbm :: !Int !Int -> Real
readOpmChannelPowerDbm opmId channelIndex =
    ~12.5 // nominal input power in dBm
