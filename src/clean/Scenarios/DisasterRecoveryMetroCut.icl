
implementation module Etalon.Scenarios.DisasterRecoveryMetroCut

import StdEnv
import Etalon.Scenarios.DisasterRecoveryMetroCut
import Etalon.Topologies.MetroRing

runMetroCutRecoverySimulation :: Bool
runMetroCutRecoverySimulation =
    let ring = buildMetroRing
    in ring.nodeCount == 8
