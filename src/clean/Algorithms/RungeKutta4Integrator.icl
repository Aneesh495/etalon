
implementation module Etalon.Algorithms.RungeKutta4Integrator

import StdEnv
import Etalon.Algorithms.RungeKutta4Integrator
import Etalon.Types.Base

integrateRk4Step :: !(Real Real -> Real) !Real !Real !Real -> Real
integrateRk4Step f t y h =
    let k1 = f t y
        k2 = f (t + 0.5 * h) (y + 0.5 * h * k1)
        k3 = f (t + 0.5 * h) (y + 0.5 * h * k2)
        k4 = f (t + h) (y + h * k3)
    in y + (h / 6.0) * (k1 + 2.0 * k2 + 2.0 * k3 + k4)
