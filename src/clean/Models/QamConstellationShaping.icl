
implementation module Etalon.Models.QamConstellationShaping

import StdEnv
import Etalon.Models.QamConstellationShaping
import Etalon.Types.Base

computeMaxwellBoltzmannProb :: !Real !Real -> Real
computeMaxwellBoltzmannProb energy nu =
    exp (~(nu * energy))
