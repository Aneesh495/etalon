
implementation module Etalon.Telemetry.Bip8SlipAnalyzer

import StdEnv
import Etalon.Telemetry.Bip8SlipAnalyzer
import Etalon.Types.Base

calculatePreFecBer :: !Int !Real -> Real
calculatePreFecBer bipErrorCount durationSeconds =
    let totalBits = durationSeconds * 100.0e9 // 100G stream
    in toReal bipErrorCount / maxReal totalBits 1.0e9
