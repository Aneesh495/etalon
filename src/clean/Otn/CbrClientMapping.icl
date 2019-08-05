implementation module Etalon.Otn.CbrClientMapping

/*
 * CbrClientMapping.icl: CBR client mapping implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.CbrClientMapping
import Etalon.Types.Base
import Etalon.Otn.Frame

getCbrSpecs :: !CbrClientProtocol -> CbrMappingContainer
getCbrSpecs CbrFibreChannel32G = {
    protocol           = CbrFibreChannel32G,
    nominalBitrateGbps = 28.05,
    targetOtnContainer = OduFlex 23,
    tolerancePpm       = 100.0
 }
getCbrSpecs CbrCpriOption7 = {
    protocol           = CbrCpriOption7,
    nominalBitrateGbps = 9.8304,
    targetOtnContainer = Otu2,
    tolerancePpm       = 0.002
 }
getCbrSpecs CbrEcpri25G = {
    protocol           = CbrEcpri25G,
    nominalBitrateGbps = 25.78125,
    targetOtnContainer = OduFlex 21,
    tolerancePpm       = 100.0
 }

computeClockOffsetHz :: !CbrMappingContainer !Real -> Real
computeClockOffsetHz specs measuredBitrateGbps =
    (measuredBitrateGbps - specs.nominalBitrateGbps) * 1.0e9
