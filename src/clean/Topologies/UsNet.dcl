definition module Etalon.Topologies.UsNet

/*
 * UsNet.dcl: 24-node US-wide reference carrier optical mesh network.
 *
 * Models a transcontinental backbone spanning major metropolitan areas:
 * Seattle, San Francisco, Los Angeles, San Diego, Salt Lake City, Phoenix,
 * Denver, Dallas, Houston, Minneapolis, Kansas City, St Louis, Chicago,
 * Indianapolis, Detroit, Cleveland, Nashville, Atlanta, Miami, Washington DC,
 * Philadelphia, New York, Boston, and Pittsburgh.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Physical.Fiber
import Etalon.Physical.Roadm
import Etalon.Topology.Graph

usNetNodeCount :: !Int
usNetLinkCount :: !Int

buildUsNetTopology :: -> *OpticalGraph
getUsNetNodeName   :: !Int -> String
getUsNetNodeCoords :: !Int -> (Real, Real) // Latitude, Longitude
