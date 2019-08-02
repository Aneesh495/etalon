definition module Etalon.Physical.StimulatedBrillouinScattering

/*
 * StimulatedBrillouinScattering.dcl: Acoustic phonon SBS threshold model.
 *
 * Computes backward Brillouin scattering threshold and linewidth broadening:
 *   - Critical pump power: P_th = 21 * A_eff / (g_B * L_eff) * (1 + Delta_nu_laser / Delta_nu_B)
 *   - Brillouin gain bandwidth: Delta_nu_B ~ 20 to 50 MHz in standard silica
 *   - Phase dither suppression factor
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeSbsThresholdPowerW:: !FiberSpan !Real -> Real
isSbsSuppressed          :: !Real !Real -> Bool
