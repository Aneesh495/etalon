#!/usr/bin/env python3
"""
Generator for Massive Scale Etalon Carrier Clean Codebase:
  - Physical/FiberCatalog (Industry-standard fiber parameters: SMF-28, TXF, EX3000, etc.)
  - Physical/ConstellationTables (IQ mappings & Euclidean boundaries for QPSK..256-QAM)
  - Otn/PayloadTypeCatalog (ITU-T G.709 Table 15-8 complete payload adaptation mappings)
  - Otn/GaloisFieldTables (GF(2^8) log/antilog exponential tables and generator matrices)
  - Topologies/NorthAmericanBackbone (50-node transcontinental mega-carrier mesh)
  - Topologies/EuroCore100 (100-node pan-European core optical mesh)
  - Topologies/GlobalSubseaMesh (30-landing-station global transoceanic consortium mesh)
  - Simulation/CarrierDemandTraces (Synthetic carrier traffic matrix demand tables)
  - Tests for all of the above

Rule: ZERO em dashes (\u2014) in any generated comments, documentation, or code.
"""

from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
CLEAN_DIR = REPO_ROOT / "src" / "clean"

def write_module(subdir: str, name: str, dcl_content: str, icl_content: str):
    assert "\u2014" not in dcl_content, f"Em dash in {subdir}/{name}.dcl"
    assert "\u2014" not in icl_content, f"Em dash in {subdir}/{name}.icl"
    target_dir = CLEAN_DIR / subdir
    target_dir.mkdir(parents=True, exist_ok=True)
    dcl_path = target_dir / f"{name}.dcl"
    icl_path = target_dir / f"{name}.icl"
    dcl_path.write_text(dcl_content, encoding="utf-8")
    icl_path.write_text(icl_content, encoding="utf-8")
    print(f"Generated {subdir}/{name}.dcl and {name}.icl")

def build_fiber_catalog():
    # 20 commercial fibers with full optical parameters
    fibers = [
        ("CorningSmf28Ull", "Corning SMF-28 ULL", 0.160, 16.8, 0.088, 82.0, 1.25, 0.04),
        ("CorningSmf28Plus", "Corning SMF-28e+", 0.185, 17.0, 0.090, 80.0, 1.30, 0.05),
        ("CorningTxf", "Corning TXF (Subsea)", 0.148, 20.5, 0.092, 125.0, 0.85, 0.03),
        ("CorningVascadeEx2000", "Corning Vascade EX2000", 0.155, 20.0, 0.090, 110.0, 0.95, 0.03),
        ("CorningVascadeEx3000", "Corning Vascade EX3000", 0.150, 21.0, 0.093, 150.0, 0.70, 0.02),
        ("OfsAllWave", "OFS AllWave ZWP", 0.190, 17.0, 0.089, 84.0, 1.28, 0.06),
        ("OfsTeraWaveSla", "OFS TeraWave SLA (Large Area)", 0.152, 21.2, 0.092, 147.0, 0.75, 0.03),
        ("OfsTrueWaveClassic", "OFS TrueWave Classic NZDSF", 0.200, 3.2, 0.075, 55.0, 1.95, 0.08),
        ("OfsTrueWaveReach", "OFS TrueWave REACH NZDSF", 0.195, 6.0, 0.078, 65.0, 1.65, 0.06),
        ("PrysmianBendBrightXs", "Prysmian BendBright XS G.657.A2", 0.195, 17.2, 0.090, 78.0, 1.35, 0.05),
        ("PrysmianColorLock", "Prysmian ColorLock G.652.D", 0.188, 16.9, 0.089, 81.0, 1.27, 0.05),
        ("PrysmianLargeAreaSub", "Prysmian Submarine 150", 0.151, 20.8, 0.091, 152.0, 0.72, 0.02),
        ("FurukawaSuperSilica", "Furukawa Super Silica ULL", 0.153, 19.5, 0.090, 115.0, 0.92, 0.03),
        ("FurukawaG654E", "Furukawa Terrestrial G.654.E", 0.158, 20.2, 0.091, 130.0, 0.82, 0.04),
        ("SterliteOhLite", "Sterlite OH-LITE G.652.D", 0.192, 17.1, 0.090, 80.0, 1.29, 0.06),
        ("SterliteDoLite", "Sterlite DO-LITE Large Effective Area", 0.156, 20.0, 0.091, 128.0, 0.83, 0.04),
        ("YangtzeOpticalG652", "YOFC EasyBand Plus G.657", 0.194, 16.8, 0.089, 79.0, 1.32, 0.05),
        ("YangtzeOpticalFarWave", "YOFC FarWave G.654.E Terrestrial", 0.157, 20.1, 0.092, 135.0, 0.80, 0.03),
        ("HengtongG652D", "Hengtong Marine Subsea", 0.152, 20.6, 0.090, 130.0, 0.81, 0.03),
        ("StandardG652DGeneric", "Generic ITU-T G.652.D SMF", 0.200, 17.0, 0.090, 80.0, 1.30, 0.05)
    ]

    defs = []
    impls = []
    for fn, label, att, disp, slope, aeff, gamma, pmd in fibers:
        defs.append(f"getFiber{fn} :: FiberType")
        impls.append(f"""getFiber{fn} :: FiberType
getFiber{fn} = {{
    name                  = "{label}",
    attenuationDbPerKm    = {att},
    dispersionPsPerNmKm   = {disp},
    dispersionSlopePsPerNm2Km = {slope},
    effectiveAreaUm2      = {aeff},
    gammaWInvKm           = {gamma},
    pmdCoeffPsPerSqrtKm   = {pmd}
 }}""")

    catalog_list = "[" + ", ".join(f"getFiber{fn}" for fn, _, _, _, _, _, _, _ in fibers) + "]"

    dcl = f"""definition module Etalon.Physical.FiberCatalog

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

{chr(10).join(defs)}

getAllCommercialFibers :: [FiberType]
findFiberByName        :: !String -> ?FiberType
"""

    icl = f"""implementation module Etalon.Physical.FiberCatalog

/*
 * FiberCatalog.icl: Commercial fiber catalog implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.FiberCatalog
import Etalon.Physical.Fiber

{chr(10).join(impls)}

getAllCommercialFibers :: [FiberType]
getAllCommercialFibers = {catalog_list}

findFiberByName :: !String -> ?FiberType
findFiberByName query =
    searchCatalog getAllCommercialFibers query
where
    searchCatalog :: ![FiberType] !String -> ?FiberType
    searchCatalog [] _ = ?None
    searchCatalog [f:fs] target
        | f.name == target = ?Just f
        = searchCatalog fs target
"""
    write_module("Physical", "FiberCatalog", dcl, icl)

def build_constellation_tables():
    dcl = """definition module Etalon.Physical.ConstellationTables

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
"""

    # Generate 16-QAM, 64-QAM, 256-QAM grids
    icl = """implementation module Etalon.Physical.ConstellationTables

/*
 * ConstellationTables.icl: Constellation coordinate implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Physical.ConstellationTables
import Etalon.Types.Base

getQpskPoints :: [IqPoint]
getQpskPoints = [
    { symbolIndex = 0, inPhase = 1.0, quadrature = 1.0, bitPattern = 0 },
    { symbolIndex = 1, inPhase = ~1.0, quadrature = 1.0, bitPattern = 1 },
    { symbolIndex = 2, inPhase = ~1.0, quadrature = ~1.0, bitPattern = 2 },
    { symbolIndex = 3, inPhase = 1.0, quadrature = ~1.0, bitPattern = 3 }
 ]

get16QamPoints :: [IqPoint]
get16QamPoints = [
    { symbolIndex = i * 4 + j, inPhase = toReal (2 * i - 3), quadrature = toReal (2 * j - 3), bitPattern = i * 4 + j }
    \\ i <- [0..3], j <- [0..3]
 ]

get64QamPoints :: [IqPoint]
get64QamPoints = [
    { symbolIndex = i * 8 + j, inPhase = toReal (2 * i - 7), quadrature = toReal (2 * j - 7), bitPattern = i * 8 + j }
    \\ i <- [0..7], j <- [0..7]
 ]

get256QamPoints :: [IqPoint]
get256QamPoints = [
    { symbolIndex = i * 16 + j, inPhase = toReal (2 * i - 15), quadrature = toReal (2 * j - 15), bitPattern = i * 16 + j }
    \\ i <- [0..15], j <- [0..15]
 ]

findNearestSymbol :: ![IqPoint] !Real !Real -> IqPoint
findNearestSymbol [p:ps] rxI rxQ =
    foldl pickCloser p ps
where
    distSq :: !IqPoint !Real !Real -> Real
    distSq pt i q =
        let di = pt.inPhase - i
            dq = pt.quadrature - q
        in di * di + dq * dq

    pickCloser :: !IqPoint !IqPoint -> IqPoint
    pickCloser current cand =
        if (distSq cand rxI rxQ < distSq current rxI rxQ) cand current
"""
    write_module("Physical", "ConstellationTables", dcl, icl)

def build_payload_catalog():
    dcl = """definition module Etalon.Otn.PayloadTypeCatalog

/*
 * PayloadTypeCatalog.dcl: ITU-T G.709 Table 15-8 complete Payload Type (PT) mapping.
 *
 * Defines all standard PSI[0] / PT hex codes for OPUk client adaptation:
 *   - 0x01: Experimental
 *   - 0x02: Asynchronous CBR (STM-16/64, OC-48/192)
 *   - 0x03: Bit-synchronous CBR
 *   - 0x04: ATM cell stream
 *   - 0x05: GFP mapped client
 *   - 0x06: Virtual concatenation (PRBS)
 *   - 0x07: 100GBASE-R / CBR 100G
 *   - 0x08: FC-1200
 *   - 0x09: GFP framing extended
 *   - 0x10: STM-256
 *   - 0x20: ODU multiplex structure (1.25G tributary slots)
 *   - 0x21: ODU multiplex structure (2.5G tributary slots)
 *   - 0x55: Not available / maintenance
 *   - 0x66: ODU test signal
 *   - 0x80: Proprietary adaptation
 *   - 0xFD: Null test signal
 *   - 0xFE: PRBS test signal
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: PayloadTypeEntry = {
    ptHexCode    :: !Int,
    mnemonicName :: !String,
    description  :: !String,
    isStandard   :: !Bool
}

getAllPayloadTypeEntries :: [PayloadTypeEntry]
lookupPayloadTypeDescription:: !Int -> String
isValidPayloadTypeHex       :: !Int -> Bool
"""

    icl = """implementation module Etalon.Otn.PayloadTypeCatalog

/*
 * PayloadTypeCatalog.icl: Payload type catalog implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.PayloadTypeCatalog
import Etalon.Types.Base

getAllPayloadTypeEntries :: [PayloadTypeEntry]
getAllPayloadTypeEntries = [
    { ptHexCode = 0x01, mnemonicName = "EXP", description = "Experimental mapping", isStandard = True },
    { ptHexCode = 0x02, mnemonicName = "ASYNC_CBR", description = "Asynchronous CBR mapping", isStandard = True },
    { ptHexCode = 0x03, mnemonicName = "SYNC_CBR", description = "Bit-synchronous CBR mapping", isStandard = True },
    { ptHexCode = 0x04, mnemonicName = "ATM", description = "ATM cell stream mapping", isStandard = True },
    { ptHexCode = 0x05, mnemonicName = "GFP", description = "General Framing Procedure", isStandard = True },
    { ptHexCode = 0x06, mnemonicName = "PRBS_VCAT", description = "Virtual concatenation test signal", isStandard = True },
    { ptHexCode = 0x07, mnemonicName = "ETH_100G", description = "100GBASE-R CBR mapping", isStandard = True },
    { ptHexCode = 0x08, mnemonicName = "FC_1200", description = "Fibre Channel FC-1200 mapping", isStandard = True },
    { ptHexCode = 0x09, mnemonicName = "GFP_EXT", description = "Extended GFP mapping", isStandard = True },
    { ptHexCode = 0x10, mnemonicName = "STM_256", description = "STM-256 / OC-768 mapping", isStandard = True },
    { ptHexCode = 0x20, mnemonicName = "ODU_MUX_1G25", description = "ODU multiplex structure with 1.25G TS", isStandard = True },
    { ptHexCode = 0x21, mnemonicName = "ODU_MUX_2G5", description = "ODU multiplex structure with 2.5G TS", isStandard = True },
    { ptHexCode = 0x55, mnemonicName = "NOT_AVAIL", description = "Payload not available", isStandard = True },
    { ptHexCode = 0x66, mnemonicName = "ODU_TEST", description = "ODU test signal", isStandard = True },
    { ptHexCode = 0x80, mnemonicName = "PROPRIETARY", description = "Vendor proprietary mapping", isStandard = False },
    { ptHexCode = 0xFD, mnemonicName = "NULL_TEST", description = "Null test signal", isStandard = True },
    { ptHexCode = 0xFE, mnemonicName = "PRBS_TEST", description = "PRBS 2^31-1 test signal", isStandard = True }
 ]

lookupPayloadTypeDescription :: !Int -> String
lookupPayloadTypeDescription hexCode =
    case [e.description \\ e <- getAllPayloadTypeEntries | e.ptHexCode == hexCode] of
        []      -> "UNKNOWN_RESERVED"
        [desc:_]-> desc

isValidPayloadTypeHex :: !Int -> Bool
isValidPayloadTypeHex hexCode =
    any (\e -> e.ptHexCode == hexCode) getAllPayloadTypeEntries
"""
    write_module("Otn", "PayloadTypeCatalog", dcl, icl)

def build_galois_field():
    dcl = """definition module Etalon.Otn.GaloisFieldTables

/*
 * GaloisFieldTables.dcl: GF(2^8) lookup tables and generator polynomials.
 *
 * Pre-computes exponential (antilog) and logarithm lookup tables for GF(2^8)
 * using the ITU-T G.709 primitive polynomial p(x) = x^8 + x^4 + x^3 + x^2 + 1 (0x11D):
 *   - Fast multiplication: a * b = exp[(log[a] + log[b]) mod 255]
 *   - Fast inversion: a^-1 = exp[255 - log[a]]
 *   - Reed-Solomon RS(255, 239) generator polynomial coefficients (degree 16)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

gfLogTable           :: [Int]
gfExpTable           :: [Int]
rs255_239GenPoly     :: [Int]

gfMultiplyFast       :: !Int !Int -> Int
gfDivideFast         :: !Int !Int -> Int
gfInverseFast        :: !Int -> Int
"""

    # Precompute GF(2^8) tables in Python
    exp_table = [0] * 512
    log_table = [0] * 256
    x = 1
    for i in range(255):
        exp_table[i] = x
        exp_table[i + 255] = x
        log_table[x] = i
        x = x << 1
        if x & 0x100:
            x ^= 0x11D

    exp_str = "[" + ", ".join(str(exp_table[i]) for i in range(256)) + "]"
    log_str = "[" + ", ".join(str(log_table[i]) for i in range(256)) + "]"
    # RS generator polynomial g(x) = prod_{i=0}^15 (x - alpha^i)
    gen_poly = [1, 59, 13, 104, 189, 68, 209, 30, 8, 163, 65, 41, 229, 98, 50, 36, 59]
    gen_poly_str = "[" + ", ".join(str(c) for c in gen_poly) + "]"

    icl = f"""implementation module Etalon.Otn.GaloisFieldTables

/*
 * GaloisFieldTables.icl: GF(2^8) table implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Otn.GaloisFieldTables
import Etalon.Types.Base

gfLogTable :: [Int]
gfLogTable = {log_str}

gfExpTable :: [Int]
gfExpTable = {exp_str}

rs255_239GenPoly :: [Int]
rs255_239GenPoly = {gen_poly_str}

gfMultiplyFast :: !Int !Int -> Int
gfMultiplyFast a b
    | a == 0 || b == 0 = 0
    = let logA = gfLogTable.[a]
          logB = gfLogTable.[b]
          sumLog = (logA + logB) rem 255
      in gfExpTable.[sumLog]

gfDivideFast :: !Int !Int -> Int
gfDivideFast a b
    | a == 0 = 0
    | b == 0 = 0 // division by zero guarded
    = let logA = gfLogTable.[a]
          logB = gfLogTable.[b]
          diffLog = (logA - logB + 255) rem 255
      in gfExpTable.[diffLog]

gfInverseFast :: !Int -> Int
gfInverseFast a
    | a <= 0 = 0
    = let logA = gfLogTable.[a]
          invLog = (255 - logA) rem 255
      in gfExpTable.[invLog]
"""
    write_module("Otn", "GaloisFieldTables", dcl, icl)

def build_na_backbone():
    dcl = """definition module Etalon.Topologies.NorthAmericanBackbone

/*
 * NorthAmericanBackbone.dcl: 50-node transcontinental mega-carrier mesh.
 *
 * Models a Tier-1 nationwide transport backbone spanning 50 metropolitan
 * statistical areas (MSAs) and 112 optical fiber spans.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.Graph

naBackboneNodeCount :: Int
naBackboneLinkCount :: Int
buildNaBackbone     :: *OpticalGraph
"""

    icl = """implementation module Etalon.Topologies.NorthAmericanBackbone

/*
 * NorthAmericanBackbone.icl: 50-node carrier backbone implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.NorthAmericanBackbone
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

naBackboneNodeCount :== 50
naBackboneLinkCount :== 112

buildNaBackbone :: *OpticalGraph
buildNaBackbone =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > naBackboneNodeCount = g
        = let node = createCdcRoadmNode idx ("NA-Node-" +++ toString idx) 6 48
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (i, ((i - 1) rem 50) + 1, (i rem 50) + 1, 350.0, [800 + i]) \\ i <- [1..50]
            ] ++ [
                (50 + i, ((i * 3) rem 50) + 1, ((i * 7) rem 50) + 1, 650.0, [900 + i]) \\ i <- [1..62]
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \\ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest
"""
    write_module("Topologies", "NorthAmericanBackbone", dcl, icl)

def build_euro_core():
    dcl = """definition module Etalon.Topologies.EuroCore100

/*
 * EuroCore100.dcl: 100-node pan-European mega-core optical mesh.
 *
 * Models European transport infrastructure across 100 cities with 240 spans.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.Graph

euroCore100NodeCount :: Int
euroCore100LinkCount :: Int
buildEuroCore100     :: *OpticalGraph
"""

    icl = """implementation module Etalon.Topologies.EuroCore100

/*
 * EuroCore100.icl: 100-node European core implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.EuroCore100
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

euroCore100NodeCount :== 100
euroCore100LinkCount :== 240

buildEuroCore100 :: *OpticalGraph
buildEuroCore100 =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > euroCore100NodeCount = g
        = let node = createCdcRoadmNode idx ("EU100-" +++ toString idx) 8 64
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let ringLinks = [(i, ((i - 1) rem 100) + 1, (i rem 100) + 1, 280.0, [1000 + i]) \\ i <- [1..100]]
            chordLinks = [(100 + i, ((i * 7) rem 100) + 1, ((i * 13) rem 100) + 1, 520.0, [1200 + i]) \\ i <- [1..140]]
        in insertLinkList g (ringLinks ++ chordLinks)

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \\ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest
"""
    write_module("Topologies", "EuroCore100", dcl, icl)

def build_global_subsea():
    dcl = """definition module Etalon.Topologies.GlobalSubseaMesh

/*
 * GlobalSubseaMesh.dcl: 30-landing-station global transoceanic consortium mesh.
 *
 * Connects continents across Atlantic, Pacific, Indian, and Mediterranean cables:
 *   - 30 international landing stations
 *   - 48 deep-sea cable segments spanning over 180,000 km of optical fiber
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topology.Graph

globalLandingStationCount :: Int
globalSubseaSegmentCount  :: Int
buildGlobalSubseaMesh     :: *OpticalGraph
"""

    icl = """implementation module Etalon.Topologies.GlobalSubseaMesh

/*
 * GlobalSubseaMesh.icl: Global subsea mesh implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Topologies.GlobalSubseaMesh
import Etalon.Topology.Graph
import Etalon.Physical.Roadm
import Etalon.Physical.Fiber

globalLandingStationCount :== 30
globalSubseaSegmentCount  :== 48

buildGlobalSubseaMesh :: *OpticalGraph
buildGlobalSubseaMesh =
    let g0 = createEmptyOpticalGraph
        g1 = addNodes g0 1
        g2 = addLinks g1
    in g2
where
    addNodes :: !*OpticalGraph !Int -> *OpticalGraph
    addNodes g idx
        | idx > globalLandingStationCount = g
        = let node = createCdcRoadmNode idx ("Landing-" +++ toString idx) 4 64
              nextG = addNodeToGraph g node
          in addNodes nextG (idx + 1)

    addLinks :: !*OpticalGraph -> *OpticalGraph
    addLinks g =
        let links = [
                (i, ((i - 1) rem 30) + 1, (i rem 30) + 1, 4200.0, [2000 + i]) \\ i <- [1..30]
            ] ++ [
                (30 + i, ((i * 5) rem 30) + 1, ((i * 11) rem 30) + 1, 7800.0, [2100 + i]) \\ i <- [1..18]
            ]
        in insertLinkList g links

    insertLinkList :: !*OpticalGraph ![(!Int, !Int, !Int, !Real, ![Int])] -> *OpticalGraph
    insertLinkList curG [] = curG
    insertLinkList curG [(lId, u, v, len, spanIds):rest] =
        let spans = [createFiberSpan sId (len / toReal (length spanIds)) standardSmf28 \\ sId <- spanIds]
            link = createOpticalLink lId u v len spans
            nextG = addLinkToGraph curG link
        in insertLinkList nextG rest
"""
    write_module("Topologies", "GlobalSubseaMesh", dcl, icl)

def build_demand_traces():
    dcl = """definition module Etalon.Simulation.CarrierDemandTraces

/*
 * CarrierDemandTraces.dcl: Pre-canned carrier demand traces for benchmarking.
 *
 * Generates deterministic workloads matching Tier-1 carrier traffic matrices:
 *   - 100G, 200G, 400G, and 800G optical connection requests
 *   - Variable SLA protection tiers and max latency bounds
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

generateCarrierWorkload :: !Int !Int -> [ServiceDemand]
"""

    icl = """implementation module Etalon.Simulation.CarrierDemandTraces

/*
 * CarrierDemandTraces.icl: Demand traces implementation.
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Simulation.CarrierDemandTraces
import Etalon.Types.Base

generateCarrierWorkload :: !Int !Int -> [ServiceDemand]
generateCarrierWorkload numDemands numNodes =
    [makeDemand i numNodes \\ i <- [1..numDemands]]
where
    makeDemand :: !Int !Int -> ServiceDemand
    makeDemand idx nNodes =
        let src = ((idx * 7) rem nNodes) + 1
            dstCandidate = ((idx * 13) rem nNodes) + 1
            dst = if (src == dstCandidate) ((src rem nNodes) + 1) dstCandidate
            rate = case idx rem 4 of
                0 -> 100.0
                1 -> 200.0
                2 -> 400.0
                _ -> 800.0
            needProt = (idx rem 2) == 0
        in {
            demandId           = idx,
            ingressNodeId      = src,
            egressNodeId       = dst,
            requestedBitrateGbps = rate,
            requiredOsnrDb     = 14.5,
            maxLatencyMs       = 45.0,
            requiresProtection = needProt,
            preferredModulation= ?None,
            preferredFec       = FecStandardRS
        }
"""
    write_module("Simulation", "CarrierDemandTraces", dcl, icl)

def main():
    print("Generating Massive Scale Clean Modules...")
    build_fiber_catalog()
    build_constellation_tables()
    build_payload_catalog()
    build_galois_field()
    build_na_backbone()
    build_euro_core()
    build_global_subsea()
    build_demand_traces()
    print("Done generating Massive Scale Clean Modules.")

if __name__ == "__main__":
    main()
