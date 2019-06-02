definition module Etalon.Topologies.PanEuropean

/*
 * PanEuropean.dcl: 28-node Pan-European core optical backbone network.
 *
 * Models a trans-European mesh spanning London, Paris, Frankfurt, Amsterdam,
 * Brussels, Geneva, Zurich, Milan, Rome, Madrid, Barcelona, Lisbon, Dublin,
 * Copenhagen, Stockholm, Oslo, Helsinki, Warsaw, Berlin, Prague, Vienna,
 * Budapest, Zagreb, Belgrade, Bucharest, Sofia, Athens, and Istanbul.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph

panEuropeanNodeCount :: !Int
panEuropeanLinkCount :: !Int

buildPanEuropeanTopology :: -> *OpticalGraph
getPanEuroNodeName       :: !Int -> String
