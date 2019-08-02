definition module Etalon.Physical.FourWaveMixing

/*
 * FourWaveMixing.dcl: Non-degenerate Four-Wave Mixing (FWM) efficiency engine.
 *
 * Solves third-order susceptibility inter-channel beating:
 *   f_ijk = f_i + f_j - f_k
 *   Phase matching: Delta beta = beta(f_ijk) + beta(f_k) - beta(f_i) - beta(f_j)
 *   FWM efficiency: eta = (alpha^2 / (alpha^2 + Delta beta^2)) * [1 + 4*exp(-alpha*L)*sin^2(Delta beta * L / 2) / (1 - exp(-alpha*L))^2]
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber

computeFwmFrequencyHz :: !Real !Real !Real -> Real
computePhaseMismatchBeta:: !FiberSpan !Real !Real !Real -> Real
computeFwmEfficiency  :: !FiberSpan !Real -> Real
