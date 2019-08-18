definition module Etalon.Impairments.PolarizationDependentLoss

/*
 * PolarizationDependentLoss.dcl: Polarization-Dependent Loss (PDL) statistical engine.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv

:: PdlElement =
    { elementId :: !Int
    , meanPdlDb :: !Real
    }

:: PdlCascadeMetrics =
    { totalMeanPdlDb :: !Real
    , maxPdl99PercentileDb :: !Real
    , osnrPenaltyDb :: !Real
    }

cascadePdlElements :: ![PdlElement] -> PdlCascadeMetrics
