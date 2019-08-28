
implementation module Etalon.Standards.IetfTeTopologySpecs

import StdEnv
import Etalon.Standards.IetfTeTopologySpecs
import Etalon.Types.Base

getTeDefaultMetric :: !Real -> Int
getTeDefaultMetric lengthKm =
    toInt (round lengthKm)
