
implementation module Etalon.Models.ForwardErrorCorrectionCatalog

import StdEnv
import Etalon.Models.ForwardErrorCorrectionCatalog
import Etalon.Types.Base

getStandardG709RsFec :: FecScheme
getStandardG709RsFec = {
    name            = "ITU-T G.709 RS(255, 239)",
    overheadPercent = 6.69,
    preFecThreshold = 1.8e-4,
    netCodingGainDb = 6.20
 }

getOpenFecScheme :: FecScheme
getOpenFecScheme = {
    name            = "OpenFEC (oFEC)",
    overheadPercent = 15.3,
    preFecThreshold = 2.0e-2,
    netCodingGainDb = 11.10
 }

getCableLabsCfeScheme :: FecScheme
getCableLabsCfeScheme = {
    name            = "CableLabs C-FEC (Concatenated Staircase)",
    overheadPercent = 20.0,
    preFecThreshold = 1.5e-2,
    netCodingGainDb = 10.80
 }
