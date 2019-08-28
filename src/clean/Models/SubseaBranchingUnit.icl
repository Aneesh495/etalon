
implementation module Etalon.Models.SubseaBranchingUnit

import StdEnv
import Etalon.Models.SubseaBranchingUnit
import Etalon.Types.Base

createSubseaBu :: !Int !String !String !String -> SubseaBranchingUnit
createSubseaBu bId trunkA trunkB branch = {
    buId                   = bId,
    trunkPortA             = { portId = 1, landingStationName = trunkA, allocatedChannelsCount = 48 },
    trunkPortB             = { portId = 2, landingStationName = trunkB, allocatedChannelsCount = 48 },
    branchPort             = { portId = 3, landingStationName = branch, allocatedChannelsCount = 24 },
    opticalPowerSplitRatio = 0.50
 }
