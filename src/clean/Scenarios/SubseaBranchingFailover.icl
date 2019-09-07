
implementation module Etalon.Scenarios.SubseaBranchingFailover

import StdEnv
import Etalon.Scenarios.SubseaBranchingFailover
import Etalon.Topologies.PacificSubsea

runBranchingFailoverSimulation :: Bool
runBranchingFailoverSimulation =
    let cable = buildPacificSubseaCable
    in cable.nodeCount == 4
