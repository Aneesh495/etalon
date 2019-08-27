
implementation module Etalon.Validation.ItuTG873Validation

import StdEnv
import Etalon.Validation.ItuTG873Validation
import Etalon.Protection.Aps

verifyApsRequestPriority :: !ApsRequestType !ApsRequestType -> Bool
verifyApsRequestPriority req1 req2 =
    // Lockout > Forced Switch > Signal Fail > Signal Degrade > Manual Switch
    getRank req1 >= getRank req2
where
    getRank ApsLockout       = 6
    getRank ApsForcedSwitch  = 5
    getRank ApsSignalFail    = 4
    getRank ApsSignalDegrade = 3
    getRank ApsManualSwitch  = 2
    getRank ApsNoRequest     = 0
