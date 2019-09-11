# Etalon System Architecture

Etalon is a carrier-grade Dense Wavelength Division Multiplexing (DWDM) optical transport control plane, Impairment-Aware Routing and Wavelength Assignment (IA-RWA) optimization engine, and sub-50ms protection switching executive.

The heart of Etalon is authored in Concurrent Clean, leveraging uniqueness typing (`*World`, `*OpticalGraph`, `*OtnFrame`) to guarantee zero-copy, in-place state transitions with mathematical purity. Performance-critical physical kernels and 16-way interleaved Reed-Solomon codecs are implemented in C99, with Python providing CLI and instrumentation glue.

```
+-----------------------------------------------------------------------------+
|                               ETALON CLI                                    |
|             (Telemetry Dashboards, Spectrum Heatmaps, CLI)                  |
+-----------------------------------------------------------------------------+
                                      |
                                      v
+-----------------------------------------------------------------------------+
|                        CONTROL & ORCHESTRATION                              |
|   +-----------------------+ +-----------------------+ +------------------+  |
|   |   BGP-LS Link-State   | |     NETCONF / YANG    | |   PCEP / RSVP-TE |  |
|   |      (RFC 7752)       | |      (RFC 6241)       | |     (RFC 5440)   |  |
|   +-----------------------+ +-----------------------+ +------------------+  |
+-----------------------------------------------------------------------------+
                                      |
                                      v
+-----------------------------------------------------------------------------+
|                   CONCURRENT CLEAN ALGORITHMIC CORE                         |
|   +---------------------------------------------------------------------+   |
|   | IA-RWA Engine: K-Shortest Paths, FlexGrid, SRLG-Disjoint Suurballe  |   |
|   +---------------------------------------------------------------------+   |
|   | Protection Executive: Sub-50ms APS, 1+1 OCh, BSHR, P-Cycles, Mesh   |   |
|   +---------------------------------------------------------------------+   |
|   | OTN Manager: ITU-T G.709 Framer, ODUk Hierarchical Mux, BIP-8       |   |
|   +---------------------------------------------------------------------+   |
|   | Optimization: Benders Decomposition, ILP, Ant Colony, Tabu Search   |   |
|   +---------------------------------------------------------------------+   |
|   | Topology Store: Graph (*OpticalGraph), Spectrum Grid, Dynamic Churn |   |
|   +---------------------------------------------------------------------+   |
+-----------------------------------------------------------------------------+
                                      |
                                      v
+-----------------------------------------------------------------------------+
|                       C99 HIGH-THROUGHPUT KERNELS                           |
|   +------------------------+ +---------------------+ +-------------------+  |
|   | Gaussian Noise Model   | | RS(255, 239) Codec  | | Microsecond WSS   |  |
|   | Kerr Non-Linearity     | | 16-Way Interleaving | | Cross-Connect Mtx |  |
|   +------------------------+ +---------------------+ +-------------------+  |
+-----------------------------------------------------------------------------+
                                      |
                                      v
+-----------------------------------------------------------------------------+
|                    PHYSICAL OPTICAL LINE SYSTEM (OLS)                       |
|   +------------------------+ +---------------------+ +-------------------+  |
|   | ROADM / CDC Nodes      | | G.652D / G.654E     | | Hybrid EDFA /     |  |
|   | WSS 1x9 / 1x20 / 1x32  | | Subsea Fiber Spans  | | Raman Amplifiers  |  |
|   +------------------------+ +---------------------+ +-------------------+  |
+-----------------------------------------------------------------------------+
```

## Subsystem Breakdown

### 1. Physical Layer and Impairment Engine

Carrier DWDM networks operate in the C-band (191.325 THz to 196.125 THz) across standard single-mode fiber (ITU-T G.652.D) and low-loss large-effective-area subsea fiber (ITU-T G.654.E).

Optical signal degradation is governed by:
- Attenuation: Compensated by Erbium-Doped Fiber Amplifiers (EDFA) and distributed Raman amplifiers.
- Chromatic Dispersion (CD): Evaluated per span and compensated through coherent Digital Signal Processing (DSP) electronic dispersion compensation (EDC).
- Polarization Mode Dispersion (PMD): Differential Group Delay (DGD) modeled with Maxwellian distributions.
- Non-Linear Interference (NLI): Kerr effect manifested as Self-Phase Modulation (SPM), Cross-Phase Modulation (XPM), and Four-Wave Mixing (FWM), calculated via the analytical Gaussian Noise (GN) model.

Generalized OSNR (gOSNR) combines amplified spontaneous emission (ASE) and non-linear interference:

$$ \frac{1}{\text{gOSNR}} = \frac{1}{\text{OSNR}_{\text{ASE}}} + \frac{1}{\text{SNR}_{\text{NLI}}} $$

### 2. Impairment-Aware Routing and Wavelength Assignment (IA-RWA)

The IA-RWA engine computes lightpaths in flexible grid optical networks conforming to ITU-T G.694.1 (6.25 GHz sliceability, 12.5 GHz slot granularity).

Key constraints enforced:
1. Wavelength Continuity: Along all links of an all-optical path without optoelectronic regeneration, the allocated spectrum slots must be identical.
2. Spectrum Contiguity: A service requiring $N$ slices must be allocated $N$ contiguous slices in the optical frequency domain.
3. Physical Feasibility: The computed gOSNR must exceed the required threshold of the modulation format (DP-BPSK, DP-QPSK, DP-8QAM, DP-16QAM, DP-64QAM) plus the forward error correction (FEC) operating margin.

Path discovery uses:
- Modified Yen k-shortest paths with edge weight penalties for spectral fragmentation.
- Suurballe algorithm on residual directed graphs for finding minimum-weight link-disjoint and SRLG-disjoint path pairs.
- First-Fit and Best-Fit spectrum assignment policies.

### 3. Sub-50ms Protection Switching Executive

Carrier reliability requires 99.999% availability (less than 5.26 minutes of downtime per year). When a fiber cut or transponder laser failure occurs, traffic restoration must complete within 50 milliseconds.

Etalon achieves a deterministic 28.5 ms failover sequence:
1. Defect Detection (5.0 ms): Loss of Signal (LOS) or Loss of Frame (LOF) triggers physical alarm.
2. APS Protocol Signaling (3.5 ms): ITU-T G.873.1 Automatic Protection Switching (APS) protocol exchange over the optical supervisory channel (OSC).
3. Optical Matrix Latching (20.0 ms): Micro-electromechanical systems (MEMS) or liquid crystal on silicon (LCoS) wavelength selective switch (WSS) cross-connect reconfiguration.

Total failover time: 5.0 + 3.5 + 20.0 = 28.5 ms, well under the 50 ms threshold.

### 4. Digital OTN (ITU-T G.709) Layer

The digital transmission frame conforms to ITU-T G.709 with a 4-row by 4080-column structure (16,320 bytes total):
- Columns 1 to 16: Framing Alignment Signal (FAS) and Section/Path Monitoring Overhead (OTUk/ODUk OH).
- Columns 17 to 3824: Optical Payload Unit (OPUk) data container.
- Columns 3825 to 4080: Forward Error Correction (FEC) parity bytes.

The FEC architecture utilizes 16-way byte-interleaved Reed-Solomon RS(255, 239) codes operating over Galois Field GF(2^8) with primitive polynomial:

$$ p(x) = x^8 + x^4 + x^3 + x^2 + 1 \quad (0\text{x}11\text{D}) $$

Each RS(255, 239) sub-codeword corrects up to 8 symbol (byte) errors per block, providing up to 6.2 dB net coding gain (NCG).

### 5. Concurrent Clean Uniqueness Type Guarantees

Clean guarantees memory safety and in-place destructive updates without a garbage collector pause or runtime borrow checker overhead through static uniqueness typing.

```clean
// A function taking a unique graph *OpticalGraph and returning a new unique *OpticalGraph
addFiberSpan :: *OpticalGraph !FiberSpan -> *OpticalGraph
```

The Clean uniqueness type system proves at compile time that:
- An object marked with `*` has exactly one reference in the execution graph.
- The compiler generates destructive, in-place machine code equivalent to C pointer mutation.
- Referential transparency and equational reasoning are maintained mathematically.
