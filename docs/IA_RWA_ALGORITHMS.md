# Impairment-Aware Routing and Wavelength Assignment (IA-RWA)

Routing and Wavelength Assignment (RWA) in carrier DWDM systems allocates physical fiber paths and optical frequency slots to connection requests subject to physical layer impairments, spectrum continuity, and non-overlapping slot constraints.

## 1. Problem Formulation

Given:
- An optical topology graph $G = (V, E)$, where $V$ represents ROADM nodes and $E$ represents directional fiber spans.
- Each link $e \in E$ has available spectrum divided into $M$ slices of width $\Delta f = 6.25 \, \text{GHz}$ (up to 768 slices in the C-band).
- A traffic demand matrix $D = \{(s_k, d_k, B_k, \text{SLA}_k)\}$, where $s_k, d_k \in V$ are the source and destination nodes, $B_k$ is the requested bit rate in Gbps, and $\text{SLA}_k$ is the availability tier.

Objective:
Minimize total spectrum slot consumption and maximize physical margin while meeting all traffic requests without blocking.

Subject to:
1. Routing Disjointness: Primary and protection paths must not share common fiber conduits (SRLG disjointness).
2. Spectrum Continuity: The center frequency $f_c$ must remain identical along all intermediate transparent ROADM nodes:

$$ f_c(e_1) = f_c(e_2) = \dots = f_c(e_m) \quad \forall e_i \in \text{Path}(k) $$

3. Spectrum Contiguity: The allocated slot must occupy $S_k = \lceil B_k / (R_s \cdot m) \rceil$ adjacent slices.
4. Physical Reach Feasibility:

$$ \text{gOSNR}(\text{Path}(k)) \ge \text{gOSNR}_{\text{threshold}}(\text{Modulation}_k) + \text{Margin}_{\text{margin}} $$

## 2. Path Discovery: K-Shortest Path with Priority Queue

Path finding is implemented in Concurrent Clean using Dijkstra search with priority queues:

```clean
dijkstraKShortestPaths :: !OpticalGraph !Int !Int !Int -> [Path]
```

Algorithm Steps:
1. Compute the shortest physical path $P_0$ between source and destination using link physical lengths as metrics.
2. For each path $k \in [1, K-1]$:
   - Identify candidate deviation nodes along path $P_{k-1}$.
   - Temporarily prune incident edges to force alternate branch exploration.
   - Insert candidate paths into a binary min-heap sorted by accumulated fiber distance and dispersion.
   - Pop the minimum metric path and verify that it is distinct from previously selected paths.

## 3. Disjoint Paths: Suurballe's Algorithm

For protected services (1+1 OCh or 1:1 Shared), Suurballe's algorithm finds two link-disjoint paths between $s$ and $d$ of minimum total length:

1. Run Dijkstra from $s$ to compute shortest path tree $T$ and node distances $d(u)$.
2. Transform edge weights: $w'(u, v) = w(u, v) - d(v) + d(u) \ge 0$.
3. Reverse the edges along the shortest path $P_1$ and assign them negative or zero residual weights.
4. Run Dijkstra on the modified residual graph to find augmenting path $P_2$.
5. Cancel antiparallel overlapping edges between $P_1$ and $P_2$ to form two disjoint paths $P_{\text{primary}}$ and $P_{\text{backup}}$.

## 4. Spectrum Allocation Policies

Etalon supports three spectrum allocation policies:
- First-Fit (FF): Scans the flexible grid from 191.325 THz upward and selects the first contiguous block of $S_k$ available slots. First-Fit concentrates allocations, leaving large free blocks at higher frequencies.
- Best-Fit (BF): Evaluates all available spectral gaps across the candidate path and chooses the gap whose size is closest to $S_k$, minimizing residual fragmented slices.
- Random-Fit (RF): Selects uniformly at random among all viable blocks, used primarily for Monte Carlo baseline comparisons.

## 5. Hitless Spectrum Defragmentation

Dynamic churn (service establishment and teardown) causes spectral fragmentation. Etalon implements Make-Before-Break (MBB) defragmentation:
1. Identify fragmented channels with non-contiguous guard bands.
2. Calculate target consolidated slot positions.
3. Establish parallel secondary media channel on destination slots.
4. Switch client traffic to the new frequency within sub-microsecond DSP alignment.
5. Tear down initial slots without dropped packets or traffic interruption.
