definition module Etalon.Topology.OpticalSpectrumGrid

/*
 * OpticalSpectrumGrid.dcl: ITU-T G.694.1 DWDM grid definition engine.
 *
 * Implements standard C-band and L-band spectrum boundaries:
 *   - C-Band: 191.300 THz to 196.100 THz (4.8 THz bandwidth, 384 slices)
 *   - L-Band: 186.100 THz to 190.900 THz (4.8 THz bandwidth, 384 slices)
 *   - 6.25 GHz central frequency granularity, 12.5 GHz slot width
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

isFrequencyInCband     :: !Real -> Bool
isFrequencyInLband     :: !Real -> Bool
computeSlotIndex       :: !Real -> Int
