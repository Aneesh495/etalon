
definition module Etalon.Models.OpticalSpectrumAnalyzer

import StdEnv
import Etalon.Types.Base

:: OsaMeasurement = {
    startFreqHz      :: !Real,
    stopFreqHz       :: !Real,
    resolutionBwGhz  :: !Real,
    peakPowerDbm     :: !Real,
    noiseFloorDbm    :: !Real
}

computeMeasuredOsnrDb :: !OsaMeasurement -> Real
