
implementation module Etalon.Examples.PcepSignalingDemonstration

import StdEnv
import Etalon.Examples.PcepSignalingDemonstration
import Etalon.Protocols.Pcep

runPcepDemonstration :: Bool
runPcepDemonstration =
    let sess = createPcepSession 1 "192.168.10.1" 30
    in sess.sessionId == 1
