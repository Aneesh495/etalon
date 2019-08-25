
implementation module Etalon.Topologies.DragonflyPlusOptical

import StdEnv
import Etalon.Topologies.DragonflyPlusOptical
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

dragonflyGroupCount :== 16

buildDragonflyPlusFabric :: *OpticalGraph
buildDragonflyPlusFabric =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
    in g1
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > 64 = g
        = let node = createCdcRoadmNode idx ("DFly-" +++ toString idx) 8 64
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)
