definition module Etalon.Topologies.TransatlanticSubsea

/*
 * TransatlanticSubsea.dcl: 6,600 km Transoceanic Submarine Cable System.
 *
 * Models an ultra-long-haul transoceanic optical cable (e.g. Dunant / Marea / TAT-14)
 * connecting North America (Virginia Beach) and Europe (Saint-Hilaire-de-Riez / Bilbao).
 * Features:
 *   - Pure silica core fiber (PSCF) with 0.15 dB/km ultra-low attenuation
 *   - 110 submerged optical repeaters spaced at 60 km intervals
 *   - Space-Division Multiplexing (SDM) with 12 to 24 fiber pairs
 *   - Positive dispersion uncompensated link with coherent DSP equalization
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Amplifier
import Etalon.Physical.Roadm
import Etalon.Topology.Graph

subseaCableLengthKm  :== 6600.0
subseaRepeaterCount  :== 110
subseaRepeaterSpacingKm :== 60.0

buildSubseaTopology  :: -> *OpticalGraph
getSubseaRepeaterGainDb :: -> Real
