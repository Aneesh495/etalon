
definition module Etalon.Standards.G872ArchitectureSpecs

import StdEnv
import Etalon.Types.Base

:: OtnArchitecturalLayer =
    LayerOts                           // Optical Transmission Section
  | LayerOms                           // Optical Multiplex Section
  | LayerOch                           // Optical Channel
  | LayerOdu                           // Optical Data Unit
  | LayerOpu                           // Optical Payload Unit

getLayerHierarchyRank :: !OtnArchitecturalLayer -> Int
