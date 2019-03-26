definition module Etalon.Physical.QFactor

/*
 * QFactor.dcl: Q-factor, Bit Error Rate (BER), and FEC margin evaluation.
 *
 * Implements Q-factor conversion, complementary error function (erfc) approximations,
 * and pre-FEC / post-FEC BER threshold margin verification for coherent optical links.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Modulation
import Etalon.Types.OpticalSignal

:: ReachAssessment = {
    evaluatedModulation :: !ModulationFormat,
    evaluatedFec        :: !FecType,
    linearSnr           :: !Real,
    osnrDb              :: !Real,
    qFactorDb           :: !Real,
    estimatedPreFecBer  :: !Real,
    fecMarginDb         :: !Real,
    isReachFeasible     :: !Bool
}

// Q-factor and BER primitives
snrLinearToQFactorDb   :: !Real !ModulationFormat -> Real
qFactorLinearFromDb    :: !Real -> Real
qFactorDbToLinear      :: !Real -> Real
qFactorToBer           :: !Real -> Real
berToQFactorLinear     :: !Real -> Real
erfcApprox             :: !Real -> Real

// Physical reach validation
assessLightpathReach   :: !Real !ModulationFormat !FecType -> ReachAssessment
findBestModulationForSnr :: !Real !FecType -> ModulationFormat
