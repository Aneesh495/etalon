
definition module Etalon.Hardware.LaserDriverRegisters

import StdEnv
import Etalon.Types.Base

:: TecPidParameters = {
    kp :: !Real,
    ki :: !Real,
    kd :: !Real
}

configureLaserTec :: !Int !TecPidParameters !Real -> Bool
