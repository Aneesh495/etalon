
implementation module Etalon.Topologies.ClosSpineLeaf800G

import StdEnv
import Etalon.Topologies.ClosSpineLeaf800G
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

closLeafCount  :== 64
closSpineCount :== 32

buildClos800GFabric :: *OpticalGraph
buildClos800GFabric =
    let g0 = createEmptyOpticalGraph
        // 64 leaves (1..64) and 32 spines (65..96)
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > 96 = g
        = let node = createCdcRoadmNode idx ("Clos-Node-" +++ toString idx) 8 128
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        // Every leaf connects to every spine: 64 * 32 = 2048 optical links
        let links = [
                (leaf * 32 + spine, leaf, 64 + spine, 0.5, [leaf * 100 + spine])
                \ leaf <- [1..64], spine <- [1..32]
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId 0.5 standardSmf28 \ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest
