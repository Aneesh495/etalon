
implementation module Etalon.Models.OpticalAddDropMultiplexer

import StdEnv
import Etalon.Models.OpticalAddDropMultiplexer
import Etalon.Types.Base

defaultOadmSpecs :: OadmSpecs
defaultOadmSpecs = {
    architecture        = OadmThinFilmFilter,
    expressLossDb       = 1.5,
    dropLossDb          = 3.5,
    addLossDb           = 3.5,
    adjacentIsolationDb = 35.0
 }
