
implementation module Etalon.Telemetry.PolarizationScramblingTracker

import StdEnv
import Etalon.Telemetry.PolarizationScramblingTracker
import Etalon.Types.Base

computeDopPercent :: !StokesVector -> Real
computeDopPercent sv =
    // Degree of Polarization DOP = sqrt(S1^2 + S2^2 + S3^2) / S0 * 100%
    let polarizedPower = sqrt (sv.s1 * sv.s1 + sv.s2 * sv.s2 + sv.s3 * sv.s3)
    in if (sv.s0 <= 0.0) 100.0 ((polarizedPower / sv.s0) * 100.0)
