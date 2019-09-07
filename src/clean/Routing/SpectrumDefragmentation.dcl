definition module Etalon.Routing.SpectrumDefragmentation

/*
 * SpectrumDefragmentation.dcl: Hitless push-pull spectrum defragmentation.
 *
 * Compacts fragmented optical spectrum using make-before-break retuning:
 *   - Shannon entropy fragmentation metric evaluation
 *   - Hitless frequency tuning using flexible-grid fine step increments
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.NetworkState

computeShannonFragmentationEntropy :: !SpectrumBitmap -> Real
isDefragmentationBeneficial       :: !Real -> Bool
