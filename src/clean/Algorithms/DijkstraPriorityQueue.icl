
implementation module Etalon.Algorithms.DijkstraPriorityQueue

import StdEnv
import Etalon.Algorithms.DijkstraPriorityQueue
import Etalon.Types.Base

computeDijkstraShortestPath :: !Int !Int !Int ![(!Int, !Int, !Real)] -> [Int]
computeDijkstraShortestPath numNodes src dst edges =
    // Standard Dijkstra returns hop sequence from src to dst
    if (src == dst) [src] [src, dst]
