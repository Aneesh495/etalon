definition module Etalon.Topologies.JapanBackbone

/*
 * JapanBackbone.dcl: 14-node Japanese national optical backbone network.
 *
 * Models a disaster-resilient ring-and-mesh topology spanning:
 * Sapporo, Sendai, Niigata, Tokyo East, Tokyo West, Yokohama, Nagoya,
 * Kanazawa, Kyoto, Osaka, Kobe, Hiroshima, Fukuoka, and Kumamoto.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph

japanNodeCount :: !Int
japanLinkCount :: !Int

buildJapanTopology :: -> *OpticalGraph
getJapanNodeName   :: !Int -> String
