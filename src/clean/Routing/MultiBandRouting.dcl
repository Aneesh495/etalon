definition module Etalon.Routing.MultiBandRouting

/*
 * MultiBandRouting.dcl: C+L band optical routing engine.
 *
 * Allocates spectrum across combined 9.6 THz C+L band:
 *   - Inter-band Stimulated Raman Scattering (ISRS) power transfer from C to L
 *   - Guard band isolation (100 GHz guard band between 190.9 and 191.3 THz)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: OpticalBand =
    BandC
  | BandL

selectOptimalBand      :: !Real !Real -> OpticalBand
