implementation module Etalon.Impairments.PolarizationDependentLoss

/*
 * PolarizationDependentLoss.icl: PDL cascade evaluation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Impairments.PolarizationDependentLoss

cascadePdlElements :: ![PdlElement] -> PdlCascadeMetrics
cascadePdlElements elements =
    let sumSq = sumPdlSquares elements 0.0
        meanCascaded = sqrt sumSq
        p99 = meanCascaded * 1.58
        penalty = 0.12 * p99 + 0.03 * (p99 * p99)
    in { totalMeanPdlDb = meanCascaded
       , maxPdl99PercentileDb = p99
       , osnrPenaltyDb = penalty
       }

sumPdlSquares :: ![PdlElement] !Real -> Real
sumPdlSquares [] acc = acc
sumPdlSquares [e:es] acc = sumPdlSquares es (acc + (e.meanPdlDb * e.meanPdlDb))
