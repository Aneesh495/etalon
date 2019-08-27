
implementation module Etalon.Validation.ItuTG709Validation

import StdEnv
import Etalon.Validation.ItuTG709Validation
import Etalon.Otn.Frame

verifyFrameDimensions :: !OtnFrame -> Bool
verifyFrameDimensions f =
    otnNumRows == 4 && otnNumCols == 4080

verifyFasPattern :: !OtnFrame -> Bool
verifyFasPattern f =
    let b1 = getFrameByte f 1 1
        b4 = getFrameByte f 1 4
    in b1 == 0xF6 && b4 == 0x28
