
implementation module Etalon.Security.PhysicalLayerIntrusionAlarm

import StdEnv
import Etalon.Security.PhysicalLayerIntrusionAlarm
import Etalon.Types.Base

isIntrusionSuspected :: !Real -> Bool
isIntrusionSuspected polarizationRotationRateRadPerSec =
    polarizationRotationRateRadPerSec >= 1000.0 // rapid mechanical vibration
