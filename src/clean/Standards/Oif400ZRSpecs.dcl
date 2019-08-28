
definition module Etalon.Standards.Oif400ZRSpecs

import StdEnv
import Etalon.Types.Base

:: Oif400ZrParameters = {
    operatingBaudRate :: !Real,
    minTargetOsnrDb   :: !Real,
    cfecOverheadPercent:: !Real
}

default400ZrParameters :: Oif400ZrParameters
