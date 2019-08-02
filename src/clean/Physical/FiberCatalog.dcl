definition module Etalon.Physical.FiberCatalog

/*
 * FiberCatalog.dcl: Comprehensive catalog of commercial optical fibers.
 *
 * Provides exact experimental parameters for Corning, OFS, Prysmian, Furukawa,
 * and standard ITU-T G.652.D, G.654.E, G.655, and G.657 specifications.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.Fiber

getFiberCorningSmf28Ull :: FiberType
getFiberCorningSmf28Plus :: FiberType
getFiberCorningTxf :: FiberType
getFiberCorningVascadeEx2000 :: FiberType
getFiberCorningVascadeEx3000 :: FiberType
getFiberOfsAllWave :: FiberType
getFiberOfsTeraWaveSla :: FiberType
getFiberOfsTrueWaveClassic :: FiberType
getFiberOfsTrueWaveReach :: FiberType
getFiberPrysmianBendBrightXs :: FiberType
getFiberPrysmianColorLock :: FiberType
getFiberPrysmianLargeAreaSub :: FiberType
getFiberFurukawaSuperSilica :: FiberType
getFiberFurukawaG654E :: FiberType
getFiberSterliteOhLite :: FiberType
getFiberSterliteDoLite :: FiberType
getFiberYangtzeOpticalG652 :: FiberType
getFiberYangtzeOpticalFarWave :: FiberType
getFiberHengtongG652D :: FiberType
getFiberStandardG652DGeneric :: FiberType

getAllCommercialFibers :: [FiberType]
findFiberByName        :: !String -> ?FiberType
