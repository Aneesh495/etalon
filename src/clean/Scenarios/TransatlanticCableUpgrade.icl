
implementation module Etalon.Scenarios.TransatlanticCableUpgrade

import StdEnv
import Etalon.Scenarios.TransatlanticCableUpgrade
import Etalon.Topologies.TransatlanticSubsea

runTransatlanticUpgradeSimulation :: Bool
runTransatlanticUpgradeSimulation =
    let cable = buildTransatlanticCable
    in cable.linkCount == 3
