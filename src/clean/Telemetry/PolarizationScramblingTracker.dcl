
definition module Etalon.Telemetry.PolarizationScramblingTracker

import StdEnv
import Etalon.Types.Base

:: StokesVector = {
    s0 :: !Real,
    s1 :: !Real,
    s2 :: !Real,
    s3 :: !Real
}

computeDopPercent :: !StokesVector -> Real
