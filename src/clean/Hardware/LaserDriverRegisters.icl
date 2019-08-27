
implementation module Etalon.Hardware.LaserDriverRegisters

import StdEnv
import Etalon.Hardware.LaserDriverRegisters
import Etalon.Types.Base

configureLaserTec :: !Int !TecPidParameters !Real -> Bool
configureLaserTec laserId pid targetTempC =
    targetTempC >= 15.0 && targetTempC <= 50.0
