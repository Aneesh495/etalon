
definition module Etalon.Standards.OpenZRPlusSpecs

import StdEnv
import Etalon.Types.Base

:: OpenZrPlusMode =
    ZrPlus100GQpsk
  | ZrPlus200G16Qam
  | ZrPlus400G16Qam

getMaxReachKm :: !OpenZrPlusMode -> Real
