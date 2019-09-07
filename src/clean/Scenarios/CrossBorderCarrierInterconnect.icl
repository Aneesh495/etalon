
implementation module Etalon.Scenarios.CrossBorderCarrierInterconnect

import StdEnv
import Etalon.Scenarios.CrossBorderCarrierInterconnect
import Etalon.Topologies.PanEuropean

runCarrierInterconnectSimulation :: Bool
runCarrierInterconnectSimulation =
    let net = buildPanEuropean
    in net.nodeCount == 28
