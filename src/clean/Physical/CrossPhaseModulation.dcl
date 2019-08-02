definition module Etalon.Physical.CrossPhaseModulation

/*
 * CrossPhaseModulation.dcl: Multi-channel Cross-Phase Modulation (XPM).
 *
 * Models pump-probe Kerr nonlinear phase modulation in DWDM systems:
 *   - XPM phase shift: dPhi_probe / dz = 2 * gamma * P_pump(z)
 *   - Walk-off length: L_w = T_0 / |d_12| where d_12 is group velocity mismatch
 *   - XPM frequency response function H_XPM(Omega)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeWalkOffLengthKm :: !FiberSpan !Real !Real -> Real
computeXpmPhaseShiftRad:: !FiberSpan !Real !Real -> Real
