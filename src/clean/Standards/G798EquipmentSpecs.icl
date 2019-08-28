
implementation module Etalon.Standards.G798EquipmentSpecs

import StdEnv
import Etalon.Standards.G798EquipmentSpecs
import Etalon.Types.Base

isTerminalFunction :: !OtnAtomicFunction -> Bool
isTerminalFunction OtuTrailTermination = True
isTerminalFunction _                   = False
