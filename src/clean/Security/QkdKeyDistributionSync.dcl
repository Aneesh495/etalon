
definition module Etalon.Security.QkdKeyDistributionSync

import StdEnv
import Etalon.Types.Base

:: QkdSession = {
    sessionId :: !Int,
    keyRateKbps:: !Real,
    qberPercent:: !Real
}

isQkdSecure :: !QkdSession -> Bool
