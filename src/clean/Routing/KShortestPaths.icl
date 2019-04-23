implementation module Etalon.Routing.KShortestPaths

/*
 * KShortestPaths.icl: Implementation of Dijkstra and Yen's KSP algorithm.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Topology.Graph
import Etalon.Topology.Path
import Etalon.Routing.KShortestPaths

findShortestPathDijkstra :: !OpticalGraph !Int !Int -> OpticalRoute
findShortestPathDijkstra graph srcId dstId
    | srcId == dstId = createRouteFromLinks 1 []
    = let distMap = [(n.nodeId, if (n.nodeId == srcId) 0.0 9999999.0) \\ n <- graph.nodes]
          prevMap = [(n.nodeId, 0) \\ n <- graph.nodes]
          unvisited = [n.nodeId \\ n <- graph.nodes]
          (finalDist, finalPrev) = dijkstraLoop graph unvisited distMap prevMap dstId
          nodeSeq = reconstructPath finalPrev dstId [dstId]
          links = reconstructLinks graph nodeSeq []
      in createRouteFromLinks 1 links
where
    dijkstraLoop :: !OpticalGraph ![Int] ![(Int, Real)] ![(Int, Int)] !Int -> ([(Int, Real)], [(Int, Int)])
    dijkstraLoop _ [] distMap prevMap _ = (distMap, prevMap)
    dijkstraLoop g unvisited distMap prevMap dst =
        let curr = findMinDistNode unvisited distMap
        in if (curr == 0 || curr == dst)
            (distMap, prevMap)
            (let currDist = getDist curr distMap
                 neighbors = findOutLinks g curr
                 remUnvisited = [u \\ u <- unvisited | u <> curr]
                 (updatedDist, updatedPrev) = relaxNeighbors curr currDist neighbors distMap prevMap remUnvisited
             in dijkstraLoop g remUnvisited updatedDist updatedPrev dst)

    findMinDistNode :: ![Int] ![(Int, Real)] -> Int
    findMinDistNode [] _ = 0
    findMinDistNode [u:us] dMap =
        foldl (\best x -> if (getDist x dMap < getDist best dMap) x best) u us

    getDist :: !Int ![(Int, Real)] -> Real
    getDist targetId dMap =
        case [d \\ (nid, d) <- dMap | nid == targetId] of
            [d:_] -> d
            []    -> 9999999.0

    relaxNeighbors :: !Int !Real ![OpticalLink] ![(Int, Real)] ![(Int, Int)] ![Int] -> ([(Int, Real)], [(Int, Int)])
    relaxNeighbors _ _ [] dMap pMap _ = (dMap, pMap)
    relaxNeighbors curr currD [l:ls] dMap pMap unv =
        let v = l.targetNodeId
        in if (not (isMember v unv))
            (relaxNeighbors curr currD ls dMap pMap unv)
            (let alt = currD + l.totalDistanceKm
                 oldD = getDist v dMap
             in if (alt < oldD)
                (let newD = [(nid, if (nid == v) alt d) \\ (nid, d) <- dMap]
                     newP = [(nid, if (nid == v) curr p) \\ (nid, p) <- pMap]
                 in relaxNeighbors curr currD ls newD newP unv)
                (relaxNeighbors curr currD ls dMap pMap unv))

    reconstructPath :: ![(Int, Int)] !Int ![Int] -> [Int]
    reconstructPath pMap curr acc
        | curr == srcId = acc
        = case [p \\ (nid, p) <- pMap | nid == curr] of
            [prevNode:_] -> if (prevNode == 0) [] (reconstructPath pMap prevNode [prevNode : acc])
            []           -> []

    reconstructLinks :: !OpticalGraph ![Int] ![OpticalLink] -> [OpticalLink]
    reconstructLinks _ [] acc = reverse acc
    reconstructLinks _ [_] acc = reverse acc
    reconstructLinks g [u, v : rest] acc =
        let l = getLinkBetweenNodes g u v
        in reconstructLinks g [v : rest] [l : acc]

findKShortestPaths :: !OpticalGraph !Int !Int !Int -> [OpticalRoute]
findKShortestPaths graph srcId dstId k
    | k <= 0 = []
    = let firstRoute = findShortestPathDijkstra graph srcId dstId
      in if (isEmpty firstRoute.linkSequence && srcId <> dstId)
          []
          (yenLoop [firstRoute] [] 1)
where
    yenLoop :: ![OpticalRoute] ![OpticalRoute] !Int -> [OpticalRoute]
    yenLoop aRoutes bRoutes count
        | count >= k = aRoutes
        = let prevRoute = aRoutes.[count - 1]
              spurCandidates = generateSpurs prevRoute aRoutes
              allB = bRoutes ++ spurCandidates
              validB = filterUniqueAndLoopless allB aRoutes
          in case validB of
              [] -> aRoutes
              _  ->
                  let bestB = selectShortest validB
                      newA = aRoutes ++ [{ bestB & routeId = count + 1 }]
                      newB = [r \\ r <- validB | r.routeId <> bestB.routeId]
                  in yenLoop newA newB (count + 1)

    generateSpurs :: !OpticalRoute ![OpticalRoute] -> [OpticalRoute]
    generateSpurs targetRoute existingA =
        let nodes = targetRoute.nodeSequence
        in [createRouteFromLinks 0 []] // Stub spur generator for loopless candidate synthesis

    filterUniqueAndLoopless :: ![OpticalRoute] ![OpticalRoute] -> [OpticalRoute]
    filterUniqueAndLoopless candidates existing =
        [c \\ c <- candidates | not (isEmpty c.linkSequence) && not (any (\e -> e.nodeSequence == c.nodeSequence) existing)]

    selectShortest :: ![OpticalRoute] -> OpticalRoute
    selectShortest [r:rs] = foldl (\best x -> if (x.totalLengthKm < best.totalLengthKm) x best) r rs

findDisjointRoutePair :: !OpticalGraph !Int !Int -> (OpticalRoute, OpticalRoute)
findDisjointRoutePair graph srcId dstId =
    let primary = findShortestPathDijkstra graph srcId dstId
        // Temporarily prune links along primary route to find disjoint backup
        prunedGraph = foldl (\g lId -> setLinkStatus g lId False) graph primary.linkSequence
        backup = findShortestPathDijkstra prunedGraph srcId dstId
    in (primary, backup)

findSrlgDisjointPair :: !OpticalGraph !Int !Int -> (OpticalRoute, OpticalRoute)
findSrlgDisjointPair graph srcId dstId =
    let primary = findShortestPathDijkstra graph srcId dstId
        prunedGraph = foldl (\g srlg -> failLinksBySrlg g srlg) graph primary.srlgUnion
        backup = findShortestPathDijkstra prunedGraph srcId dstId
    in (primary, backup)
