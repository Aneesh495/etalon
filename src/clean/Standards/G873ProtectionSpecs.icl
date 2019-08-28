
implementation module Etalon.Standards.G873ProtectionSpecs

import StdEnv
import Etalon.Standards.G873ProtectionSpecs
import Etalon.Types.Base

getHoldOffTimerMs :: Int
getHoldOffTimerMs = 100

getWaitToRestoreTimerSec :: Int
getWaitToRestoreTimerSec = 300 // 5 minutes WTR
