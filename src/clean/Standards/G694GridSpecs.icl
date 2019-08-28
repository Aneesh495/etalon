
implementation module Etalon.Standards.G694GridSpecs

import StdEnv
import Etalon.Standards.G694GridSpecs
import Etalon.Types.Base

computeAnchorFreqHz :: !Int -> Real
computeAnchorFreqHz n =
    // f = 193.1 THz + n * 0.00625 THz
    193.1e12 + toReal n * 6.25e9
