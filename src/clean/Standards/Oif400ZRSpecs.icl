
implementation module Etalon.Standards.Oif400ZRSpecs

import StdEnv
import Etalon.Standards.Oif400ZRSpecs
import Etalon.Types.Base

default400ZrParameters :: Oif400ZrParameters
default400ZrParameters = {
    operatingBaudRate   = 59.84375e9,
    minTargetOsnrDb     = 26.0,
    cfecOverheadPercent = 15.0
 }
