
implementation module Etalon.Monitoring.OduPerformancePrimitives

import StdEnv
import Etalon.Monitoring.OduPerformancePrimitives
import Etalon.Types.Base

isSeverelyErroredSecond :: !Int -> Bool
isSeverelyErroredSecond blockErrors =
    blockErrors >= 30 // typical SES threshold
