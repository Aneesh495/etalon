# The Gaussian Noise (GN) Physical-Layer Impairment Model

## 1. Physical Foundations

Optical signal propagation along a single-mode optical fiber is governed by the Non-Linear Schrodinger Equation (NLSE):

$$ \frac{\partial A}{\partial z} + \frac{\alpha}{2} A + i \frac{\beta_2}{2} \frac{\partial^2 A}{\partial t^2} - \frac{\beta_3}{6} \frac{\partial^3 A}{\partial t^3} = -i \gamma |A|^2 A $$

Where:
- $A(z, t)$ is the slowly varying complex electric field envelope.
- $\alpha$ is the fiber attenuation coefficient (in nepers/meter).
- $\beta_2$ is the group velocity dispersion parameter (in $\text{s}^2/\text{m}$).
- $\beta_3$ is the third-order dispersion parameter.
- $\gamma$ is the Kerr non-linear coefficient (in $\text{W}^{-1}\text{m}^{-1}$), defined as:

$$ \gamma = \frac{2 \pi n_2}{\lambda A_{\text{eff}}} $$

With $n_2 \approx 2.6 \times 10^{-20} \, \text{m}^2/\text{W}$ and $A_{\text{eff}} \approx 80 \, \mu\text{m}^2$.

## 2. Derivation of Non-Linear Interference (NLI) Power Spectral Density

Under high chromatic dispersion accumulation (uncompensated coherent transmission), the non-linear interactions across wavelength division multiplexed channels can be modeled as an additive Gaussian noise process.

Using first-order perturbation theory, the non-linear interference power spectral density $G_{\text{NLI}}(f)$ at the center frequency of the channel under test (CUT) over a single fiber span of length $L_s$ is expressed as:

$$ G_{\text{NLI}}(0) = \frac{16}{27} \gamma^2 \int_{-\infty}^{\infty} \int_{-\infty}^{\infty} G_{\text{WDM}}(f_1) G_{\text{WDM}}(f_2) G_{\text{WDM}}(f_1 + f_2) |\rho(f_1, f_2)|^2 \, df_1 \, df_2 $$

Where the four-wave mixing phase matching efficiency function $\rho(f_1, f_2)$ is given by:

$$ \rho(f_1, f_2) = \int_{0}^{L_s} e^{-\alpha z} e^{i \Delta \beta(f_1, f_2) z} \, dz = \frac{1 - e^{-\alpha L_s} e^{i \Delta \beta L_s}}{\alpha - i \Delta \beta} $$

And the phase mismatch parameter is:

$$ \Delta \beta(f_1, f_2) = -4 \pi^2 \beta_2 f_1 f_2 $$

## 3. Analytical Asymptotic Closed-Form Solution

For a dense WDM comb consisting of $N_{\text{ch}}$ channels with optical bandwidth $B_{\text{opt}} = N_{\text{ch}} \cdot \Delta f$, symbol rate $R_s$, and channel launch power $P_{\text{ch}}$, the double integral reduces to the closed-form inverse hyperbolic sine formulation:

$$ G_{\text{NLI}}(0) \approx \frac{16}{27} \frac{\gamma^2 P_{\text{ch}}^3}{\pi |\beta_2| R_s^2} \operatorname{asinh}\left( \frac{\pi^2}{2} \frac{|\beta_2|}{\alpha} B_{\text{opt}}^2 \right) $$

For a multi-span link consisting of $N_{\text{spans}}$ identical spans with incoherent noise accumulation across spans:

$$ P_{\text{NLI}} = N_{\text{spans}} \cdot G_{\text{NLI}}(0) \cdot R_s $$

## 4. Amplified Spontaneous Emission (ASE) Noise

Each Erbium-Doped Fiber Amplifier (EDFA) compensates for the span attenuation $G = e^{\alpha L_s}$ and introduces Amplified Spontaneous Emission noise. The ASE noise power in both polarizations over reference bandwidth $B_{\text{ref}}$ (conventionally 0.1 nm = 12.5 GHz at 1550 nm) is:

$$ P_{\text{ASE}} = 2 \cdot n_{\text{sp}} \cdot h \nu \cdot (G - 1) \cdot B_{\text{ref}} = F_n \cdot h \nu \cdot G \cdot B_{\text{ref}} $$

Where:
- $h = 6.62607015 \times 10^{-34} \, \text{J}\cdot\text{s}$ (Planck constant).
- $\nu \approx 193.1 \, \text{THz}$ (optical carrier frequency).
- $F_n = 10^{\text{NF}_{\text{dB}} / 10}$ is the linear amplifier noise figure.

Over an $N_{\text{spans}}$ transparent optical link:

$$ P_{\text{ASE, total}} = \sum_{k=1}^{N_{\text{spans}}} F_{n, k} \cdot h \nu \cdot G_k \cdot B_{\text{ref}} $$

## 5. Generalized OSNR and Bit Error Rate (BER)

The Generalized Optical Signal-to-Noise Ratio (gOSNR) combines linear ASE noise and non-linear Kerr interference:

$$ \text{gOSNR} = \frac{P_{\text{ch}}}{P_{\text{ASE}} + P_{\text{NLI}}} $$

From gOSNR, the effective electrical signal-to-noise ratio $\text{SNR}_{\text{eff}}$ per symbol for coherent dual-polarization modulation is determined. The Q-factor is calculated as:

$$ Q_{\text{dB}} \approx \text{SNR}_{\text{dB}} - 3.01 $$

The pre-FEC Bit Error Rate is obtained using the complementary error function:

$$ \text{BER} = \frac{1}{2} \operatorname{erfc}\left( \frac{Q_{\text{linear}}}{\sqrt{2}} \right) $$

A lightpath is determined physically feasible if and only if:

$$ \text{BER} \le \text{BER}_{\text{threshold, FEC}} \quad \text{and} \quad \text{gOSNR}_{\text{margin}} \ge 1.5 \, \text{dB} $$
