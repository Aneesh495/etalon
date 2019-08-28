
implementation module Etalon.Models.FiberNonlinearityCatalog

import StdEnv
import Etalon.Models.FiberNonlinearityCatalog
import Etalon.Types.Base

getStandardSilicaParameters :: FiberNonlinearParameters
getStandardSilicaParameters = {
    glassType           = "Standard Silica GeO2-SiO2",
    n2RefractiveIndexM2W= 2.6e-20,
    ramanPeakGainWInvM  = 1.0e-13,
    brillouinShiftGhz   = 10.85
 }
