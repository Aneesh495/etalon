
implementation module Etalon.Topologies.HyperXOpticalFabric

import StdEnv
import Etalon.Topologies.HyperXOpticalFabric
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

buildHyperXFabric :: *OpticalGraph
buildHyperXFabric =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
    in g1
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > 36 = g
        = let node = createCdcRoadmNode idx ("HyperX-" +++ toString idx) 6 48
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)
