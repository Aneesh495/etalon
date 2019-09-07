
implementation module Etalon.Scenarios.NationwideSpectrumDefrag

import StdEnv
import Etalon.Scenarios.NationwideSpectrumDefrag
import Etalon.Topologies.UsNet

runNationwideDefragSimulation :: Bool
runNationwideDefragSimulation =
    let net = buildUsNet
    in net.nodeCount == 24
