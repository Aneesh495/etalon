
definition module Etalon.Models.SubseaBranchingUnit

import StdEnv
import Etalon.Types.Base

:: SubseaBranchingPort = {
    portId           :: !Int,
    landingStationName:: !String,
    allocatedChannelsCount:: !Int
}

:: SubseaBranchingUnit = {
    buId             :: !Int,
    trunkPortA       :: !SubseaBranchingPort,
    trunkPortB       :: !SubseaBranchingPort,
    branchPort       :: !SubseaBranchingPort,
    opticalPowerSplitRatio:: !Real
}

createSubseaBu :: !Int !String !String !String -> SubseaBranchingUnit
