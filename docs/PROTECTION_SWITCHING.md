# Carrier Sub-50ms Protection Switching

Optical transport networks form the critical backbone of global telecommunications. A single fiber cut can interrupt hundreds of Terabits per second of live traffic. Consequently, carrier standards mandate restoration within 50 milliseconds.

Etalon implements an autonomous, sub-50ms protection switching executive conforming to:
- ITU-T G.873.1: Optical transport network linear protection switching (1+1 and 1:n).
- ITU-T G.873.2: ODUk Shared Protection Ring (SPRing) protocol.
- ITU-T G.808.1: Generic protection switching linear architecture and protocol.

## 1. Timeline Breakdown of Sub-50ms Protection Failover

```
Event: Fiber Cut Occurs (t = 0.0 ms)
  |
  +--> [0.0 - 5.0 ms]  Defect Detection: Loss of Signal (LOS) / Loss of Frame (LOF)
  |
  +--> [5.0 - 8.5 ms]  APS Signaling: ITU-T G.873.1 1-byte APS protocol over OSC
  |
  +--> [8.5 - 28.5 ms] Optical Cross-Connect Latching: Fast MEMS / Piezo WSS switchover
  |
Total Restoration: 28.5 ms (Well within the 50.0 ms carrier ceiling)
```

### Stage 1: Defect Detection (5.0 ms)
- Line transponders detect optical power collapse (below -30 dBm) or frame alignment loss.
- Hardware registers assert Loss of Signal (LOS) interrupt within 1.0 ms.
- A 4.0 ms hold-off validation timer filters out transient micro-bends or polarization adjustments.

### Stage 2: Automatic Protection Switching (APS) Signaling (3.5 ms)
- APS bytes (1-byte protocol field in the OTN overhead or OSC frame) are transmitted to the remote node.
- Bridge request and selector switch alignment confirmation:
  * Bit 1-4: Request type (Lockout, Forced Switch, Signal Fail, Manual Switch).
  * Bit 5-8: Requested signal channel identifier.
- Over an 800 km optical span, speed-of-light propagation in silica fiber ($n = 1.4682$) requires:

$$ t_{\text{prop}} = \frac{800 \times 10^3 \, \text{m}}{2.9979 \times 10^8 / 1.4682 \, \text{m/s}} \approx 3.91 \, \text{ms} $$

### Stage 3: Hardware Optical Cross-Connect Switching (20.0 ms)
- Micro-Electro-Mechanical Systems (MEMS) or liquid crystal on silicon (LCoS) mirrors deflect optical beams from the primary express port to the secondary protection port.
- Optical power stabilizes within 20 milliseconds, restoring bit-level continuity.

## 2. Protection Architectures

### 1+1 Optical Channel (OCh) Dedicated Protection
- Dual-feed, selective-receive architecture.
- Client signal is optical split at the ingress transponder and continuously transmitted over two fully disjoint paths (Primary and Backup).
- Egress optical receiver monitors both paths and switches reception to the backup path upon defect.
- Benefit: No reverse signaling required; fastest possible restoration (under 15 ms).
- Trade-off: 100% spectrum redundancy.

### 1:1 and 1:N Shared Protection
- Traffic normally traverses the primary path; the backup path is idle or carries lower-priority pre-emptible traffic.
- When the primary path fails, both nodes coordinate via APS to bridge and select the backup path.
- Benefit: Protection spectrum can be shared among multiple non-concurrent failure groups.

### Four-Fiber Bi-Directional Switched Ring (BSHR-4)
- Implements both Span Switching (for single fiber link cuts) and Ring Switching (for complete cable or node failures).
- Working channels on fiber pair 1/2; protection channels on fiber pair 3/4.
- Span switch restores traffic locally around the cut link in less than 25 ms without looping back around the whole ring.

### Pre-Configured Protection Cycles (P-Cycles)
- Provides mesh network efficiency with ring-like switching speeds.
- For links on the cycle, protection requires 1 switch.
- For straddling links (links not on the cycle whose endpoints lie on the cycle), the p-cycle protects two unit-capacity working channels.
