
implementation module Etalon.Validation.ItuTG694Validation

import StdEnv
import Etalon.Validation.ItuTG694Validation
import Etalon.Types.Base
import Etalon.Types.Spectrum

verifySlotWidthValid :: !FrequencySlot -> Bool
verifySlotWidthValid slot =
    // Slot width m must be a positive integer (m * 12.5 GHz)
    slot.slotWidthM >= 1 && slot.slotWidthM <= 64

verifyCenterFreqValid :: !FrequencySlot -> Bool
verifyCenterFreqValid slot =
    // Center frequency n: f = 193.1 THz + n * 6.25 GHz (-288 <= n <= 288 for C-band)
    slot.centerFreqM >= ~288 && slot.centerFreqM <= 288
