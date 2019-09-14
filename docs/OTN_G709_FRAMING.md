# ITU-T G.709 Optical Transport Network Framing and FEC

The Optical Transport Network (OTN) defined by ITU-T Recommendation G.709 provides carrier-grade transport, multiplexing, switching, management, and supervision of optical channels.

## 1. Frame Geometry

The standard OTN frame is organized as a matrix of 4 rows by 4080 columns, giving an exact frame size of 16,320 bytes:

```
        Column 1-14        Column 15-16     Column 17-3824       Column 3825-4080
      +------------------+----------------+--------------------+------------------+
Row 1 | FAS / OTU-OH     | OPU Overhead   | OPU Payload Area   | OTU FEC Parity   |
Row 2 | ODU Overhead     | OPU Overhead   | OPU Payload Area   | OTU FEC Parity   |
Row 3 | ODU Overhead     | OPU Overhead   | OPU Payload Area   | OTU FEC Parity   |
Row 4 | ODU Overhead     | OPU Overhead   | OPU Payload Area   | OTU FEC Parity   |
      +------------------+----------------+--------------------+------------------+
      |<-- 14 bytes ---> |<-- 2 bytes --> |<-- 3808 bytes ---> |<-- 256 bytes --> |
```

### Overhead Allocation:
1. Frame Alignment Signal (FAS):
   - Row 1, Columns 1 to 6.
   - Fixed framing sequence: `0xF6 0xF6 0xF6 0x28 0x28 0x28`.
   - Used for frame synchronization and bit slip detection.
2. Multi-Frame Alignment Signal (MFAS):
   - Row 1, Column 7.
   - 8-bit counter incrementing from 0 to 255 to align multi-frame structures (such as 64-byte TTI messages).
3. Section Monitoring (SM):
   - Row 1, Columns 8 to 10.
   - SM Trail Trace Identifier (TTI), SM BIP-8 parity, and SM Backward Error Indication (BEI) / Backward Defect Indication (BDI).
4. Path Monitoring (PM):
   - Row 3, Columns 10 to 12.
   - End-to-end path monitoring TTI, BIP-8, and status indicators.
5. Tandem Connection Monitoring (TCM 1-6):
   - Supports up to 6 independent nested monitoring domains across multi-carrier boundaries.

## 2. Bit-Interleaved Parity 8 (BIP-8) Calculation

BIP-8 provides non-intrusive error monitoring. The parity is calculated across the previous frame's payload and placed into the subsequent frame's overhead:

For each bit position $i \in [0, 7]$:

$$ \text{BIP8}[i] = \bigoplus_{k=1}^{N} \text{Byte}_k[i] $$

Where $\bigoplus$ represents modulo-2 addition (XOR) across all covered bytes in rows 2, 3, and 4.

## 3. Forward Error Correction: RS(255, 239) with 16-Way Interleaving

ITU-T G.709 specifies Reed-Solomon RS(255, 239) error correction:
- Codeword length $n = 255$ bytes.
- Information payload $k = 239$ bytes.
- Parity symbols $2t = 16$ bytes.
- Error correction capability $t = 8$ byte errors per codeword.
- Redundancy overhead: $16 / 239 \approx 6.69\% \approx 7\%$.

### Galois Field Construction:
The code operates over Galois Field $\text{GF}(2^8)$ constructed with the irreducible primitive polynomial:

$$ p(x) = x^8 + x^4 + x^3 + x^2 + 1 \quad (\text{hex: } 0\text{x}11\text{D}) $$

The generator polynomial $g(x)$ is defined with root $\alpha$ (primitive element of $\text{GF}(2^8)$):

$$ g(x) = \prod_{j=0}^{15} (x - \alpha^j) = x^{16} + g_{15} x^{15} + \dots + g_1 x + g_0 $$

### 16-Way Byte Interleaving:
To protect against optical burst errors (caused by polarization transients, lightning strikes on aerial cables, or acoustic vibrations), codewords are not transmitted contiguously. Instead, 16 codewords are byte-interleaved across each frame row:

```
Row Byte:  0   1   2  ...  15  16  17 ...  31  ...
Codeword: C0  C1  C2  ... C15  C0  C1 ... C15  ...
```

This 16-way interleaving disperses a physical burst error of up to $16 \times 8 = 128$ consecutive bytes (1024 consecutive bits) across separate codewords, allowing full algebraic recovery.

## 4. Algebraic Decoding Pipeline

1. Syndrome Computation:
   Evaluate received polynomial $r(x)$ at the 16 roots $\alpha^j$ ($j = 0, \dots, 15$):

$$ S_j = r(\alpha^j) $$

   If all $S_j = 0$, the block is error-free.

2. Key Equation Solver:
   Run the Berlekamp-Massey algorithm to find the error locator polynomial $\Lambda(x)$ of minimal degree satisfying:

$$ \Omega(x) \equiv S(x) \cdot \Lambda(x) \pmod{x^{2t}} $$

3. Root Finding:
   Apply Chien search by evaluating $\Lambda(\alpha^{-i})$ for all positions $i \in [0, 254]$. A zero corresponds to an error at position $i$.

4. Error Magnitude Evaluation:
   Use Forney's algorithm to compute the correction value:

$$ e_i = -\frac{\Omega(\alpha^{-i})}{\Lambda'(\alpha^{-i})} $$

   Subtract $e_i$ in $\text{GF}(2^8)$ to restore the original transmitted byte.
