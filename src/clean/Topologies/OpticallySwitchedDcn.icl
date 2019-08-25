
implementation module Etalon.Topologies.OpticallySwitchedDcn

import StdEnv
import Etalon.Topologies.OpticallySwitchedDcn
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

buildOcsDcnFabric :: *OpticalGraph
buildOcsDcnFabric =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
    in g1
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > 48 = g
        = let node = createCdcRoadmNode idx ("OCS-DCN-" +++ toString idx) 4 64
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)
