
definition module Etalon.Algorithms.RungeKutta4Integrator

import StdEnv
import Etalon.Types.Base

integrateRk4Step :: !(Real Real -> Real) !Real !Real !Real -> Real
