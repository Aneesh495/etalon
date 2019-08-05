definition module Etalon.Otn.CbrClientMapping

/*
 * CbrClientMapping.dcl: Constant Bit Rate (CBR) transparent mapping.
 *
 * Maps high-speed SAN and mobile fronthaul protocols into OTN:
 *   - Fibre Channel: FC-1200 (10G), FC-3200 (32G), FC-12800 (128G)
 *   - CPRI: Option 7 (9.83 Gbps), Option 8 (10.13 Gbps), eCPRI (25G)
 *   - BMP bit-synchronous and AMP asynchronous mapping
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Otn.Frame

:: CbrClientProtocol =
    CbrFibreChannel32G
  | CbrCpriOption7
  | CbrEcpri25G

:: CbrMappingContainer = {
    protocol           :: !CbrClientProtocol,
    nominalBitrateGbps :: !Real,
    targetOtnContainer :: !OtuRate,
    tolerancePpm       :: !Real
}

getCbrSpecs            :: !CbrClientProtocol -> CbrMappingContainer
computeClockOffsetHz   :: !CbrMappingContainer !Real -> Real
