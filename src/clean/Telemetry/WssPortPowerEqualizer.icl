
implementation module Etalon.Telemetry.WssPortPowerEqualizer

import StdEnv
import Etalon.Telemetry.WssPortPowerEqualizer
import Etalon.Types.Base

computeVoaCorrectionDb :: !Real !Real -> Real
computeVoaCorrectionDb targetPowerDbm measuredPowerDbm =
    measuredPowerDbm - targetPowerDbm
