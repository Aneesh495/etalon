
implementation module Etalon.Hardware.OtdrRegisters

import StdEnv
import Etalon.Hardware.OtdrRegisters
import Etalon.Types.Base

triggerOtdrTrace :: !Int !OtdrConfig -> Bool
triggerOtdrTrace spanId cfg =
    cfg.pulseWidthNs > 0 && cfg.rangeKm > 0.0
