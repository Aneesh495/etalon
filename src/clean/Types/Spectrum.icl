implementation module Etalon.Types.Spectrum

/*
 * Spectrum.icl: Implementation of flexible grid spectrum allocation and fragmentation metrics.
 *
 * Implements high-throughput bitwise allocation over 64-bit words with
 * uniqueness typing (*SpectrumBitmap) for zero-copy state transitions.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base
import Etalon.Types.Spectrum

createFrequencySlot :: !Int !Int -> FrequencySlot
createFrequencySlot n m =
    let center = refOpticalFreqHz + ((toReal n) * sliceWidthHz)
        bw = (toReal m) * slotGranularityHz
        slicesReq = m * 2
        refSlice = totalSlices / 2
        start = refSlice + n - (slicesReq / 2)
    in {
        nIndex       = n,
        mWidth       = m,
        startSlice   = start,
        sliceCount   = slicesReq,
        centerFreqHz = center,
        bandwidthHz  = bw
    }

initSpectrumBitmap :: !Int -> *SpectrumBitmap
initSpectrumBitmap num =
    let words = (num + 63) / 64
        mask = [0 \\ _ <- [1..words]]
    in {
        numSlices      = num,
        allocatedMask  = mask,
        freeSliceCount = num
    }

cloneSpectrumBitmap :: !SpectrumBitmap -> SpectrumBitmap
cloneSpectrumBitmap bm = {
    numSlices      = bm.numSlices,
    allocatedMask  = [w \\ w <- bm.allocatedMask],
    freeSliceCount = bm.freeSliceCount
}

isSliceFree :: !SpectrumBitmap !Int -> Bool
isSliceFree bm slice
    | slice < 0 || slice >= bm.numSlices = False
    = let wordIdx = slice / 64
          bitIdx = slice rem 64
          wordVal = bm.allocatedMask.[wordIdx]
      in (wordVal bitand (1 << bitIdx)) == 0

isRangeFree :: !SpectrumBitmap !Int !Int -> Bool
isRangeFree bm start len
    | start < 0 || (start + len) > bm.numSlices = False
    | len <= 0                                  = True
    = checkRange bm start len 0
where
    checkRange :: !SpectrumBitmap !Int !Int !Int -> Bool
    checkRange bm s l offset
        | offset >= l = True
        | not (isSliceFree bm (s + offset)) = False
        = checkRange bm s l (offset + 1)

findFirstFit :: !SpectrumBitmap !Int -> Int
findFirstFit bm requiredLen
    | requiredLen <= 0 || requiredLen > bm.freeSliceCount = -1
    = scanSlices bm 0 requiredLen
where
    scanSlices :: !SpectrumBitmap !Int !Int -> Int
    scanSlices bm current required
        | (current + required) > bm.numSlices = -1
        | isRangeFree bm current required      = current
        = scanSlices bm (current + 1) required

countContiguousFree :: !SpectrumBitmap !Int -> Int
countContiguousFree bm start
    | start < 0 || start >= bm.numSlices = 0
    | not (isSliceFree bm start)         = 0
    = 1 + (countContiguousFree bm (start + 1))

findBestFit :: !SpectrumBitmap !Int -> Int
findBestFit bm requiredLen
    | requiredLen <= 0 || requiredLen > bm.freeSliceCount = -1
    = searchBest bm 0 -1 999999
where
    searchBest :: !SpectrumBitmap !Int !Int !Int -> Int
    searchBest bm idx bestIdx bestSpan
        | idx >= bm.numSlices = bestIdx
        | isSliceFree bm idx =
            let span = countContiguousFree bm idx
            in if (span >= requiredLen && span < bestSpan)
                (searchBest bm (idx + span) idx span)
                (searchBest bm (idx + span) bestIdx bestSpan)
        = searchBest bm (idx + 1) bestIdx bestSpan

allocateSliceRange :: !*SpectrumBitmap !Int !Int -> *SpectrumBitmap
allocateSliceRange bm=:{numSlices} start len
    | start < 0 || (start + len) > numSlices || len <= 0 = bm
    = updateBits bm start len True

releaseSliceRange :: !*SpectrumBitmap !Int !Int -> *SpectrumBitmap
releaseSliceRange bm=:{numSlices} start len
    | start < 0 || (start + len) > numSlices || len <= 0 = bm
    = updateBits bm start len False

updateBits :: !*SpectrumBitmap !Int !Int !Bool -> *SpectrumBitmap
updateBits bm=:{allocatedMask,freeSliceCount} start len setOccupied =
    let newMask = applyBits allocatedMask start len setOccupied
        delta = if setOccupied (~len) len
    in { bm & allocatedMask = newMask, freeSliceCount = freeSliceCount + delta }
where
    applyBits :: !.[Int] !Int !Int !Bool -> .[Int]
    applyBits mask s l occupied
        | l <= 0 = mask
        = let wordIdx = s / 64
              bitIdx = s rem 64
              currWord = mask.[wordIdx]
              maskBit = 1 << bitIdx
              newWord = if occupied (currWord bitor maskBit) (currWord bitand (bitnot maskBit))
              updatedMask = { mask & [wordIdx] = newWord }
          in applyBits updatedMask (s + 1) (l - 1) occupied

computeExternalFragmentation :: !SpectrumBitmap -> Real
computeExternalFragmentation bm
    | bm.freeSliceCount == 0 = 0.0
    = let maxBlock = findMaxFreeBlock bm 0 0
          maxBlockReal = toReal maxBlock
          freeTotalReal = toReal bm.freeSliceCount
      in 1.0 - (maxBlockReal / freeTotalReal)
where
    findMaxFreeBlock :: !SpectrumBitmap !Int !Int -> Int
    findMaxFreeBlock bm idx maxSoFar
        | idx >= bm.numSlices = maxSoFar
        | isSliceFree bm idx =
            let span = countContiguousFree bm idx
                newMax = if (span > maxSoFar) span maxSoFar
            in findMaxFreeBlock bm (idx + span) newMax
        = findMaxFreeBlock bm (idx + 1) maxSoFar

computeShannonEntropy :: !SpectrumBitmap -> Real
computeShannonEntropy bm
    | bm.freeSliceCount == 0 = 0.0
    = let blocks = collectFreeBlockSizes bm 0
          totalFree = toReal bm.freeSliceCount
      in calcEntropy blocks totalFree 0.0
where
    collectFreeBlockSizes :: !SpectrumBitmap !Int -> [Int]
    collectFreeBlockSizes bm idx
        | idx >= bm.numSlices = []
        | isSliceFree bm idx =
            let span = countContiguousFree bm idx
            in [span : collectFreeBlockSizes bm (idx + span)]
        = collectFreeBlockSizes bm (idx + 1)

    calcEntropy :: ![Int] !Real !Real -> Real
    calcEntropy [] _ acc = acc
    calcEntropy [b:bs] total acc =
        let p = (toReal b) / total
            term = ~ (p * (log10 p) / (log10 2.0))
        in calcEntropy bs total (acc + term)
