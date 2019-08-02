implementation module Etalon.Physical.FiberCatalog

/*
 * FiberCatalog.icl: Commercial fiber catalog implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.FiberCatalog
import Etalon.Physical.Fiber

getFiberCorningSmf28Ull :: FiberType
getFiberCorningSmf28Ull = {
    name                  = "Corning SMF-28 ULL",
    attenuationDbPerKm    = 0.16,
    dispersionPsPerNmKm   = 16.8,
    dispersionSlopePsPerNm2Km = 0.088,
    effectiveAreaUm2      = 82.0,
    gammaWInvKm           = 1.25,
    pmdCoeffPsPerSqrtKm   = 0.04
 }
getFiberCorningSmf28Plus :: FiberType
getFiberCorningSmf28Plus = {
    name                  = "Corning SMF-28e+",
    attenuationDbPerKm    = 0.185,
    dispersionPsPerNmKm   = 17.0,
    dispersionSlopePsPerNm2Km = 0.09,
    effectiveAreaUm2      = 80.0,
    gammaWInvKm           = 1.3,
    pmdCoeffPsPerSqrtKm   = 0.05
 }
getFiberCorningTxf :: FiberType
getFiberCorningTxf = {
    name                  = "Corning TXF (Subsea)",
    attenuationDbPerKm    = 0.148,
    dispersionPsPerNmKm   = 20.5,
    dispersionSlopePsPerNm2Km = 0.092,
    effectiveAreaUm2      = 125.0,
    gammaWInvKm           = 0.85,
    pmdCoeffPsPerSqrtKm   = 0.03
 }
getFiberCorningVascadeEx2000 :: FiberType
getFiberCorningVascadeEx2000 = {
    name                  = "Corning Vascade EX2000",
    attenuationDbPerKm    = 0.155,
    dispersionPsPerNmKm   = 20.0,
    dispersionSlopePsPerNm2Km = 0.09,
    effectiveAreaUm2      = 110.0,
    gammaWInvKm           = 0.95,
    pmdCoeffPsPerSqrtKm   = 0.03
 }
getFiberCorningVascadeEx3000 :: FiberType
getFiberCorningVascadeEx3000 = {
    name                  = "Corning Vascade EX3000",
    attenuationDbPerKm    = 0.15,
    dispersionPsPerNmKm   = 21.0,
    dispersionSlopePsPerNm2Km = 0.093,
    effectiveAreaUm2      = 150.0,
    gammaWInvKm           = 0.7,
    pmdCoeffPsPerSqrtKm   = 0.02
 }
getFiberOfsAllWave :: FiberType
getFiberOfsAllWave = {
    name                  = "OFS AllWave ZWP",
    attenuationDbPerKm    = 0.19,
    dispersionPsPerNmKm   = 17.0,
    dispersionSlopePsPerNm2Km = 0.089,
    effectiveAreaUm2      = 84.0,
    gammaWInvKm           = 1.28,
    pmdCoeffPsPerSqrtKm   = 0.06
 }
getFiberOfsTeraWaveSla :: FiberType
getFiberOfsTeraWaveSla = {
    name                  = "OFS TeraWave SLA (Large Area)",
    attenuationDbPerKm    = 0.152,
    dispersionPsPerNmKm   = 21.2,
    dispersionSlopePsPerNm2Km = 0.092,
    effectiveAreaUm2      = 147.0,
    gammaWInvKm           = 0.75,
    pmdCoeffPsPerSqrtKm   = 0.03
 }
getFiberOfsTrueWaveClassic :: FiberType
getFiberOfsTrueWaveClassic = {
    name                  = "OFS TrueWave Classic NZDSF",
    attenuationDbPerKm    = 0.2,
    dispersionPsPerNmKm   = 3.2,
    dispersionSlopePsPerNm2Km = 0.075,
    effectiveAreaUm2      = 55.0,
    gammaWInvKm           = 1.95,
    pmdCoeffPsPerSqrtKm   = 0.08
 }
getFiberOfsTrueWaveReach :: FiberType
getFiberOfsTrueWaveReach = {
    name                  = "OFS TrueWave REACH NZDSF",
    attenuationDbPerKm    = 0.195,
    dispersionPsPerNmKm   = 6.0,
    dispersionSlopePsPerNm2Km = 0.078,
    effectiveAreaUm2      = 65.0,
    gammaWInvKm           = 1.65,
    pmdCoeffPsPerSqrtKm   = 0.06
 }
getFiberPrysmianBendBrightXs :: FiberType
getFiberPrysmianBendBrightXs = {
    name                  = "Prysmian BendBright XS G.657.A2",
    attenuationDbPerKm    = 0.195,
    dispersionPsPerNmKm   = 17.2,
    dispersionSlopePsPerNm2Km = 0.09,
    effectiveAreaUm2      = 78.0,
    gammaWInvKm           = 1.35,
    pmdCoeffPsPerSqrtKm   = 0.05
 }
getFiberPrysmianColorLock :: FiberType
getFiberPrysmianColorLock = {
    name                  = "Prysmian ColorLock G.652.D",
    attenuationDbPerKm    = 0.188,
    dispersionPsPerNmKm   = 16.9,
    dispersionSlopePsPerNm2Km = 0.089,
    effectiveAreaUm2      = 81.0,
    gammaWInvKm           = 1.27,
    pmdCoeffPsPerSqrtKm   = 0.05
 }
getFiberPrysmianLargeAreaSub :: FiberType
getFiberPrysmianLargeAreaSub = {
    name                  = "Prysmian Submarine 150",
    attenuationDbPerKm    = 0.151,
    dispersionPsPerNmKm   = 20.8,
    dispersionSlopePsPerNm2Km = 0.091,
    effectiveAreaUm2      = 152.0,
    gammaWInvKm           = 0.72,
    pmdCoeffPsPerSqrtKm   = 0.02
 }
getFiberFurukawaSuperSilica :: FiberType
getFiberFurukawaSuperSilica = {
    name                  = "Furukawa Super Silica ULL",
    attenuationDbPerKm    = 0.153,
    dispersionPsPerNmKm   = 19.5,
    dispersionSlopePsPerNm2Km = 0.09,
    effectiveAreaUm2      = 115.0,
    gammaWInvKm           = 0.92,
    pmdCoeffPsPerSqrtKm   = 0.03
 }
getFiberFurukawaG654E :: FiberType
getFiberFurukawaG654E = {
    name                  = "Furukawa Terrestrial G.654.E",
    attenuationDbPerKm    = 0.158,
    dispersionPsPerNmKm   = 20.2,
    dispersionSlopePsPerNm2Km = 0.091,
    effectiveAreaUm2      = 130.0,
    gammaWInvKm           = 0.82,
    pmdCoeffPsPerSqrtKm   = 0.04
 }
getFiberSterliteOhLite :: FiberType
getFiberSterliteOhLite = {
    name                  = "Sterlite OH-LITE G.652.D",
    attenuationDbPerKm    = 0.192,
    dispersionPsPerNmKm   = 17.1,
    dispersionSlopePsPerNm2Km = 0.09,
    effectiveAreaUm2      = 80.0,
    gammaWInvKm           = 1.29,
    pmdCoeffPsPerSqrtKm   = 0.06
 }
getFiberSterliteDoLite :: FiberType
getFiberSterliteDoLite = {
    name                  = "Sterlite DO-LITE Large Effective Area",
    attenuationDbPerKm    = 0.156,
    dispersionPsPerNmKm   = 20.0,
    dispersionSlopePsPerNm2Km = 0.091,
    effectiveAreaUm2      = 128.0,
    gammaWInvKm           = 0.83,
    pmdCoeffPsPerSqrtKm   = 0.04
 }
getFiberYangtzeOpticalG652 :: FiberType
getFiberYangtzeOpticalG652 = {
    name                  = "YOFC EasyBand Plus G.657",
    attenuationDbPerKm    = 0.194,
    dispersionPsPerNmKm   = 16.8,
    dispersionSlopePsPerNm2Km = 0.089,
    effectiveAreaUm2      = 79.0,
    gammaWInvKm           = 1.32,
    pmdCoeffPsPerSqrtKm   = 0.05
 }
getFiberYangtzeOpticalFarWave :: FiberType
getFiberYangtzeOpticalFarWave = {
    name                  = "YOFC FarWave G.654.E Terrestrial",
    attenuationDbPerKm    = 0.157,
    dispersionPsPerNmKm   = 20.1,
    dispersionSlopePsPerNm2Km = 0.092,
    effectiveAreaUm2      = 135.0,
    gammaWInvKm           = 0.8,
    pmdCoeffPsPerSqrtKm   = 0.03
 }
getFiberHengtongG652D :: FiberType
getFiberHengtongG652D = {
    name                  = "Hengtong Marine Subsea",
    attenuationDbPerKm    = 0.152,
    dispersionPsPerNmKm   = 20.6,
    dispersionSlopePsPerNm2Km = 0.09,
    effectiveAreaUm2      = 130.0,
    gammaWInvKm           = 0.81,
    pmdCoeffPsPerSqrtKm   = 0.03
 }
getFiberStandardG652DGeneric :: FiberType
getFiberStandardG652DGeneric = {
    name                  = "Generic ITU-T G.652.D SMF",
    attenuationDbPerKm    = 0.2,
    dispersionPsPerNmKm   = 17.0,
    dispersionSlopePsPerNm2Km = 0.09,
    effectiveAreaUm2      = 80.0,
    gammaWInvKm           = 1.3,
    pmdCoeffPsPerSqrtKm   = 0.05
 }

getAllCommercialFibers :: [FiberType]
getAllCommercialFibers = [getFiberCorningSmf28Ull, getFiberCorningSmf28Plus, getFiberCorningTxf, getFiberCorningVascadeEx2000, getFiberCorningVascadeEx3000, getFiberOfsAllWave, getFiberOfsTeraWaveSla, getFiberOfsTrueWaveClassic, getFiberOfsTrueWaveReach, getFiberPrysmianBendBrightXs, getFiberPrysmianColorLock, getFiberPrysmianLargeAreaSub, getFiberFurukawaSuperSilica, getFiberFurukawaG654E, getFiberSterliteOhLite, getFiberSterliteDoLite, getFiberYangtzeOpticalG652, getFiberYangtzeOpticalFarWave, getFiberHengtongG652D, getFiberStandardG652DGeneric]

findFiberByName :: !String -> ?FiberType
findFiberByName query =
    searchCatalog getAllCommercialFibers query
where
    searchCatalog :: ![FiberType] !String -> ?FiberType
    searchCatalog [] _ = ?None
    searchCatalog [f:fs] target
        | f.name == target = ?Just f
        = searchCatalog fs target
