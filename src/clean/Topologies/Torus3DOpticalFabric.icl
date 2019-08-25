
implementation module Etalon.Topologies.Torus3DOpticalFabric

import StdEnv
import Etalon.Topologies.Torus3DOpticalFabric
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

torusDimSize :== 4 // 4x4x4 = 64 nodes

build3DTorusFabric :: *OpticalGraph
build3DTorusFabric =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
    in g1
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > 64 = g
        = let node = createCdcRoadmNode idx ("Torus-" +++ toString idx) 6 32
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)
