
implementation module Etalon.Examples.CarrierBackboneProvisioning

import StdEnv
import Etalon.Examples.CarrierBackboneProvisioning
import Etalon.Types.Base
import Etalon.Topologies.UsNet
import Etalon.Routing.ImpairmentAware
import Etalon.Protection.DedicatedProtection

runBackboneProvisioningExample :: Bool
runBackboneProvisioningExample =
    let net = buildUsNet
    in net.nodeCount == 24
