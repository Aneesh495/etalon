
implementation module Etalon.Validation.Rfc5440Validation

import StdEnv
import Etalon.Validation.Rfc5440Validation
import Etalon.Protocols.Pcep

verifyPcepMessageHeader :: !PcepMessage -> Bool
verifyPcepMessageHeader msg =
    msg.requestId >= 0
