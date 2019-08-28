
definition module Etalon.Models.QamConstellationShaping

import StdEnv
import Etalon.Types.Base

:: PcsShapingConfig = {
    targetEntropyBits:: !Real,          // e.g. 3.5 bits for 16-QAM (vs 4.0 uniform)
    shapingParameterNu:: !Real,         // Maxwell-Boltzmann distribution exponent
    snrGainDb        :: !Real           // Achieved shaping gain (up to 1.53 dB)
}

computeMaxwellBoltzmannProb :: !Real !Real -> Real
