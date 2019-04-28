implementation module Etalon.Routing.SpectrumAssign

/*
 * SpectrumAssign.icl: Implementation of spectrum allocation policies (RSA).
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum
import Etalon.Topology.Path
import Etalon.Topology.NetworkState
import Etalon.Routing.SpectrumAssign

computeRouteIntersectionBitmap :: !WorldState !OpticalRoute -> SpectrumBitmap
computeRouteIntersectionBitmap state route =
    let linkBitmaps = [getBitmap state.linkSpectrums lId \\ lId <- route.linkSequence]
    in intersectBitmaps linkBitmaps
where
    getBitmap :: ![LinkSpectrumState] !Int -> SpectrumBitmap
    getBitmap [] _ = initSpectrumBitmap totalSlices
    getBitmap [ls:rest] lId
        | ls.linkRefId == lId = ls.spectrum
        = getBitmap rest lId

    intersectBitmaps :: ![SpectrumBitmap] -> SpectrumBitmap
    intersectBitmaps [] = initSpectrumBitmap totalSlices
    intersectBitmaps [b:bs] = foldl bitwiseOrMask (cloneSpectrumBitmap b) bs

    bitwiseOrMask :: !SpectrumBitmap !SpectrumBitmap -> SpectrumBitmap
    bitwiseOrMask b1 b2 =
        // A slice is occupied on the multi-hop path if occupied on ANY link in the route
        let merged = [w1 bitor w2 \\ w1 <- b1.allocatedMask & w2 <- b2.allocatedMask]
            freeCount = countFreeWords merged
        in { b1 & allocatedMask = merged, freeSliceCount = freeCount }

    countFreeWords :: ![Int] -> Int
    countFreeWords words = sum [(64 - popcountInt w) \\ w <- words]

findCommonContiguousSlots :: !SpectrumBitmap !Int -> [Int]
findCommonContiguousSlots bm sliceCount =
    scan 0 []
where
    scan idx acc
        | (idx + sliceCount) > bm.numSlices = reverse acc
        | isRangeFree bm idx sliceCount      = scan (idx + 1) [idx : acc]
        = scan (idx + 1) acc

assignSpectrumForRoute :: !WorldState !OpticalRoute !Int !AllocationPolicy -> SpectrumAllocationResult
assignSpectrumForRoute state route slotWidthMultiplier policy =
    let reqSlices = slotWidthMultiplier * 2
        pathBitmap = computeRouteIntersectionBitmap state route
        startSlice = case policy of
            PolicyFirstFit         -> findFirstFit pathBitmap reqSlices
            PolicyBestFit          -> findBestFit pathBitmap reqSlices
            PolicyExactFit         -> findExactFit pathBitmap reqSlices
            PolicyMinFragmentation -> findMinFragFit pathBitmap reqSlices
    in if (startSlice < 0)
        {
            allocatedSlot      = createFrequencySlot 0 slotWidthMultiplier,
            success            = False,
            searchedSlices     = pathBitmap.numSlices,
            fragmentationDelta = 0.0
        }
        (let slot = createFrequencySlot (startSlice - (totalSlices / 2)) slotWidthMultiplier
             fragBefore = computeExternalFragmentation pathBitmap
             updatedBm = allocateSliceRange (cloneSpectrumBitmap pathBitmap) startSlice reqSlices
             fragAfter = computeExternalFragmentation updatedBm
         in {
            allocatedSlot      = slot,
            success            = True,
            searchedSlices     = startSlice + reqSlices,
            fragmentationDelta = fragAfter - fragBefore
         })
where
    findExactFit :: !SpectrumBitmap !Int -> Int
    findExactFit bm targetLen =
        let candidates = findCommonContiguousSlots bm targetLen
            exactMatches = [c \\ c <- candidates | countContiguousFree bm c == targetLen]
        in case exactMatches of
            [e:_] -> e
            []    -> findBestFit bm targetLen

    findMinFragFit :: !SpectrumBitmap !Int -> Int
    findMinFragFit bm targetLen =
        let candidates = findCommonContiguousSlots bm targetLen
        in case candidates of
            [] -> -1
            _  -> foldl (evaluateCandidate bm targetLen) (hd candidates) (tl candidates)

    evaluateCandidate :: !SpectrumBitmap !Int !Int !Int -> Int
    evaluateCandidate bm req bestCandidate current =
        let bmBest = allocateSliceRange (cloneSpectrumBitmap bm) bestCandidate req
            bmCurr = allocateSliceRange (cloneSpectrumBitmap bm) current req
            fragBest = computeExternalFragmentation bmBest
            fragCurr = computeExternalFragmentation bmCurr
        in if (fragCurr < fragBest) current bestCandidate

policyToString :: !AllocationPolicy -> String
policyToString PolicyFirstFit         = "First-Fit"
policyToString PolicyBestFit          = "Best-Fit"
policyToString PolicyExactFit         = "Exact-Fit"
policyToString PolicyMinFragmentation = "Minimum-Fragmentation"
