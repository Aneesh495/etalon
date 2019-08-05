definition module Etalon.Otn.GmpSignalingJustification

/*
 * GmpSignalingJustification.dcl: Generic Mapping Procedure (GMP) rate adaptation.
 *
 * Computes exact byte justification according to ITU-T G.709 Annex D:
 *   - Client byte count: C_m(t) = Floor(P_server / P_client * m)
 *   - Sigma-Delta stuffing distribution algorithm
 *   - Fractional stuffing phase parameter C_8(t)
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

:: GmpStuffingProfile = {
    mBytesCount        :: !Int,        // Server payload size in bytes
    clientBytesAllocated:: !Int,       // C_m(t)
    stuffBytesCount    :: !Int,        // S_m(t) = m - C_m(t)
    deltaPhaseAccum    :: !Int
}

computeGmpParameters  :: !Real !Real !Int -> GmpStuffingProfile
isBytePositionPayload :: !GmpStuffingProfile !Int -> Bool
