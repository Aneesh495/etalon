
definition module Etalon.Models.ForwardErrorCorrectionCatalog

import StdEnv
import Etalon.Types.Base

:: FecScheme = {
    name             :: !String,
    overheadPercent  :: !Real,
    preFecThreshold  :: !Real,
    netCodingGainDb  :: !Real
}

getStandardG709RsFec :: FecScheme
getOpenFecScheme     :: FecScheme
getCableLabsCfeScheme:: FecScheme
