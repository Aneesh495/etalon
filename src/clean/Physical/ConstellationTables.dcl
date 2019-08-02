definition module Etalon.Physical.ConstellationTables

/*
 * ConstellationTables.dcl: In-phase and Quadrature (I/Q) constellation coordinates.
 *
 * Provides exact Gray-mapped 2D coordinate points and Voronoi decision regions:
 *   - BPSK (2 points)
 *   - QPSK (4 points)
 *   - 8-QAM (8 points circular & square)
 *   - 16-QAM (16 points square)
 *   - 32-QAM (32 points cross)
 *   - 64-QAM (64 points square)
 *   - 128-QAM (128 points cross)
 *   - 256-QAM (256 points square)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: IqPoint = {
    symbolIndex :: !Int,
    inPhase     :: !Real,
    quadrature  :: !Real,
    bitPattern  :: !Int
}

getQpskPoints   :: [IqPoint]
get16QamPoints  :: [IqPoint]
get64QamPoints  :: [IqPoint]
get256QamPoints :: [IqPoint]
findNearestSymbol:: ![IqPoint] !Real !Real -> IqPoint
