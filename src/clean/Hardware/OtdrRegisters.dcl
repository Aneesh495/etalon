
definition module Etalon.Hardware.OtdrRegisters

import StdEnv
import Etalon.Types.Base

:: OtdrConfig = {
    pulseWidthNs       :: !Int,         // 10ns to 20us
    rangeKm            :: !Real,        // 20km to 250km
    averagingTimeSec   :: !Int          // 15s to 180s
}

triggerOtdrTrace :: !Int !OtdrConfig -> Bool
