
definition module Etalon.Standards.G798EquipmentSpecs

import StdEnv
import Etalon.Types.Base

:: OtnAtomicFunction =
    OtuTrailTermination
  | OduAdaptation
  | OduCrossConnectFunction

isTerminalFunction :: !OtnAtomicFunction -> Bool
