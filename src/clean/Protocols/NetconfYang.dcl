definition module Etalon.Protocols.NetconfYang

/*
 * NetconfYang.dcl: IETF Optical Impairment YANG model (RFC 9093).
 *
 * Generates XML payloads for optical transceivers, ROADMs, and links:
 *   - <ietf-optical-impairment-topology> YANG schema serialization
 *   - Transceiver operational power and wavelength telemetry
 *
 * Copyright (c) 2026 Aneesh Krishna. All rights reserved.
 * Distributed under the MIT License.
 */

import StdEnv
import Etalon.Types.Base

serializeYangTransceiverXml :: !Int !Real !Real -> String
serializeYangRoadmPortXml    :: !Int !Int !Real -> String
