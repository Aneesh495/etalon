
implementation module Etalon.Validation.Rfc7688Validation

import StdEnv
import Etalon.Validation.Rfc7688Validation
import Etalon.Protocols.Gmp

verifyGmplsLabelGrid :: !GmplsLabel -> Bool
verifyGmplsLabelGrid lbl =
    lbl.gridType == 1 && lbl.channelSpacingGhz == 6.25
