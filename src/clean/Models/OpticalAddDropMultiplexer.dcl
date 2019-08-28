
definition module Etalon.Models.OpticalAddDropMultiplexer

import StdEnv
import Etalon.Types.Base

:: OadmArchitecture =
    OadmThinFilmFilter
  | OadmFiberBraggGrating

:: OadmSpecs = {
    architecture     :: !OadmArchitecture,
    expressLossDb    :: !Real,
    dropLossDb       :: !Real,
    addLossDb        :: !Real,
    adjacentIsolationDb:: !Real
}

defaultOadmSpecs :: OadmSpecs
