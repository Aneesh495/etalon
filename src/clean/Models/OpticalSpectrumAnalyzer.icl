
implementation module Etalon.Models.OpticalSpectrumAnalyzer

import StdEnv
import Etalon.Models.OpticalSpectrumAnalyzer
import Etalon.Types.Base

computeMeasuredOsnrDb :: !OsaMeasurement -> Real
computeMeasuredOsnrDb osa =
    osa.peakPowerDbm - osa.noiseFloorDbm
