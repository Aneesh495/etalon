
implementation module Etalon.Models.PhotonicIntegratedCircuit

import StdEnv
import Etalon.Models.PhotonicIntegratedCircuit
import Etalon.Types.Base

defaultSiliconPic :: PicTransceiverChip
defaultSiliconPic = {
    tech          = PicSiliconPhotonics,
    laserIncluded = False,
    modulatorVPi  = 1.8,
    chipSizeMm2   = 25.0
 }
