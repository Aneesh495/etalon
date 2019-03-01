definition module Etalon.Types.Spectrum

/*
 * Spectrum.dcl: ITU-T G.694.1 flexible grid spectrum allocation and slice management.
 *
 * Models DWDM C-band optical spectrum with 6.25 GHz slice resolution and 12.5 GHz slot width.
 * Uses uniqueness typing (*SpectrumBitmap) to guarantee zero-copy in-place spectrum allocation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

// ITU-T G.694.1 Flexible Grid constants
cBandStartHz       :== 191.325e12         // 191.325 THz (lower boundary)
cBandEndHz         :== 196.125e12         // 196.125 THz (upper boundary)
sliceWidthHz       :== 6.25e9             // 6.25 GHz minimum frequency slice
slotGranularityHz  :== 12.5e9             // 12.5 GHz slot granularity (m * 12.5 GHz)
totalSlices        :== 768                // (196.125 - 191.325) THz / 6.25 GHz

// A flexible grid frequency slot defined by ITU-T (n, m) parameters:
// Center frequency = 193.1 THz + n * 0.00625 THz
// Slot width = m * 0.0125 THz
:: FrequencySlot = {
    nIndex         :: !Int,               // Central frequency multiplier
    mWidth         :: !Int,               // Slot width multiplier
    startSlice     :: !Int,               // Zero-based starting slice index (0..767)
    sliceCount     :: !Int,               // Number of occupied 6.25 GHz slices
    centerFreqHz   :: !Real,              // Absolute optical center frequency in Hz
    bandwidthHz    :: !Real               // Total optical bandwidth in Hz
}

// Uniqueness-typed spectrum allocation bitmap enabling in-place destructive mutation
:: *SpectrumBitmap = {
    numSlices      :: !Int,
    allocatedMask  :: !.[Int],            // Array of 64-bit words representing slice occupancy
    freeSliceCount :: !Int
}

// Constructor and lifecycle
initSpectrumBitmap     :: !Int -> *SpectrumBitmap
cloneSpectrumBitmap    :: !SpectrumBitmap -> SpectrumBitmap

// Query functions
isSliceFree            :: !SpectrumBitmap !Int -> Bool
isRangeFree            :: !SpectrumBitmap !Int !Int -> Bool
findFirstFit           :: !SpectrumBitmap !Int -> Int
findBestFit            :: !SpectrumBitmap !Int -> Int
countContiguousFree    :: !SpectrumBitmap !Int -> Int

// Destructive state transition functions using uniqueness typing (*SpectrumBitmap)
allocateSliceRange     :: !*SpectrumBitmap !Int !Int -> *SpectrumBitmap
releaseSliceRange      :: !*SpectrumBitmap !Int !Int -> *SpectrumBitmap

// Spectrum fragmentation metrics
computeExternalFragmentation :: !SpectrumBitmap -> Real
computeShannonEntropy        :: !SpectrumBitmap -> Real
createFrequencySlot          :: !Int !Int -> FrequencySlot
