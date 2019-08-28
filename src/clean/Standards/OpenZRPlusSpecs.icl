
implementation module Etalon.Standards.OpenZRPlusSpecs

import StdEnv
import Etalon.Standards.OpenZRPlusSpecs
import Etalon.Types.Base

getMaxReachKm :: !OpenZrPlusMode -> Real
getMaxReachKm ZrPlus100GQpsk  = 2500.0
getMaxReachKm ZrPlus200G16Qam = 1500.0
getMaxReachKm ZrPlus400G16Qam = 1000.0
