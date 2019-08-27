
definition module Etalon.Diagnostics.TransponderSelfTest

import StdEnv
import Etalon.Types.Base

:: BistStatus =
    BistPassed
  | BistFailedLaser
  | BistFailedModulator
  | BistFailedDsp

runTransponderBist :: !Int -> BistStatus
