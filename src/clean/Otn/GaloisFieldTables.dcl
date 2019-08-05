definition module Etalon.Otn.GaloisFieldTables

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
