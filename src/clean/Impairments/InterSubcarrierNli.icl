implementation module Etalon.Impairments.InterSubcarrierNli

/*
 * InterSubcarrierNli.icl: Inter-subcarrier NLI implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Impairments.InterSubcarrierNli

evaluateInterSubcarrierNli :: ![SubcarrierCarrier] !Real !Real -> InterSubcarrierResult
evaluateInterSubcarrierNli carriers gammaWkm spanDispersion =
    let count = length carriers
        pwrSum = sumPower carriers 0.0
        nliTotal = pwrSum * gammaWkm * 0.0025 * (real count)
        worstSnr = 28.0 - (10.0 * (log10 (1.0 + (nliTotal * 100.0))))
    in { totalSubcarriers = count
       , aggregateNliPowerMw = nliTotal
       , worstSubcarrierSnrDb = worstSnr
       }

sumPower :: ![SubcarrierCarrier] !Real -> Real
sumPower [] acc = acc
sumPower [c:cs] acc =
    let linPwr = 10.0 ^ (c.powerDbm / 10.0)
    in sumPower cs (acc + linPwr)
