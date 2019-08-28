
definition module Etalon.Models.PhotonicIntegratedCircuit

import StdEnv
import Etalon.Types.Base

:: PicTechnology =
    PicSiliconPhotonics
  | PicIndiumPhosphide

:: PicTransceiverChip = {
    tech             :: !PicTechnology,
    laserIncluded    :: !Bool,
    modulatorVPi     :: !Real,          // V_pi in Volts (e.g. 1.5 V)
    chipSizeMm2      :: !Real
}

defaultSiliconPic :: PicTransceiverChip
