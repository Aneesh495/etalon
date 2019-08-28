
implementation module Etalon.Examples.SubseaTransatlanticSimulation

import StdEnv
import Etalon.Examples.SubseaTransatlanticSimulation
import Etalon.Topologies.TransatlanticSubsea

runSubseaSimulationExample :: Bool
runSubseaSimulationExample =
    let cable = buildTransatlanticCable
    in cable.nodeCount == 4
