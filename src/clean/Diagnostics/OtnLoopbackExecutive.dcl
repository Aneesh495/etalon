
definition module Etalon.Diagnostics.OtnLoopbackExecutive

import StdEnv
import Etalon.Types.Base

:: LoopbackMode =
    LoopbackNone
  | LoopbackFacility
  | LoopbackTerminal
  | LoopbackLine

isTrafficLoopbackActive :: !LoopbackMode -> Bool
