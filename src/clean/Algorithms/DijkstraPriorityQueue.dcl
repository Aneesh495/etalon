
definition module Etalon.Algorithms.DijkstraPriorityQueue

import StdEnv
import Etalon.Types.Base

:: DijkstraNode = {
    nodeId   :: !Int,
    distance :: !Real,
    prevNode :: !Int
}

computeDijkstraShortestPath :: !Int !Int !Int ![(!Int, !Int, !Real)] -> [Int]
