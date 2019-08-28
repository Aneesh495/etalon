
definition module Etalon.Models.FiberNonlinearityCatalog

import StdEnv
import Etalon.Types.Base

:: FiberNonlinearParameters = {
    glassType        :: !String,
    n2RefractiveIndexM2W:: !Real,       // e.g. 2.6e-20 m^2 / W
    ramanPeakGainWInvM:: !Real,         // e.g. 1.0e-13 m / W
    brillouinShiftGhz:: !Real           // e.g. 10.8 GHz
}

getStandardSilicaParameters :: FiberNonlinearParameters
