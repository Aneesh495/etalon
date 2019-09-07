
implementation module Etalon.Security.OpticalTappingDetector

import StdEnv
import Etalon.Security.OpticalTappingDetector
import Etalon.Types.Base

isTappingDetected :: !Real !Real -> Bool
isTappingDetected baselinePowerDbm currentPowerDbm =
    // Sudden localized loss drop > 0.15 dB triggers tapping alarm
    (baselinePowerDbm - currentPowerDbm) >= 0.15
