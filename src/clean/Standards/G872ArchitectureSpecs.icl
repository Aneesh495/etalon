
implementation module Etalon.Standards.G872ArchitectureSpecs

import StdEnv
import Etalon.Standards.G872ArchitectureSpecs
import Etalon.Types.Base

getLayerHierarchyRank :: !OtnArchitecturalLayer -> Int
getLayerHierarchyRank LayerOts = 5
getLayerHierarchyRank LayerOms = 4
getLayerHierarchyRank LayerOch = 3
getLayerHierarchyRank LayerOdu = 2
getLayerHierarchyRank LayerOpu = 1
