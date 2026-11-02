# Instructor record: earlier price discussion

The following development explanation is retained for reference, outside the participant workbook.

# Unified prices, returns and the displayed model equations

This note applies to Sections 4, 5.3 and 5.4. The guide and both code folders now use the same explicit equilibrium variables. Each participant model includes every displayed condition, with the equation number in a code comment; the full files add scenario collection and plots.

| Current symbol / code | Meaning |
|---|---|
| `c` | Current consumption |
| `k(-1)` | Capital available at the beginning of t, k_(t-1); code `k` chooses k_t for t+1 |
| `n` | Hours in the elastic-labour model |
| `qtilde` | Algebraically defined detrended price, c^(-gamma)/(1+tauc) |
| `r` | Real rental yield before taxes and depreciation; the marginal product of capital |
| `w` | Real wage per unit of labour; wage income is w*n (n=1 with inelastic labour) |
| `R` | Forward consumption-adjusted gross saving return, textbook R_(t+1) |
| `s` | Current after-capital-tax payoff plus undepreciated capital, (1-tauk)*r+1-delta |

The rental yield `r` is **not** the net interest rate. Without taxes/subsidies the forward net interest rate is the future rental yield minus depreciation, and the gross return adds one. When consumption-tax or investment-subsidy wedges change, `R` includes those wedges as shown in the Euler equation. MATLAB/Octave distinguishes `r` from `R`; there is no need for an R-bar notation.

## Why the original Section 4 divided by q

The original notation expressed some factor payoffs in date-zero goods. A dated rental payoff is `q_t*r_t` in the current real-price convention. Dividing that dated payoff by `q_t` recovers the real rental yield. The same applies to wages and the current capital payoff. This converts price units; it does not rescale physical output.

The guide now calls the original quantities `r_dated`, `w_dated` and `s_dated` when explaining the conversion. Its model equations and budgets use real `r`, `w` and `s` throughout Sections 4 and 5. The former Section 5 `eta` label is replaced by `r`. Historical images are unchanged; their caption notes map old `r/q`, `w/q`, `s/q`, `eta` and R-bar labels into the current notation.

## Dated prices and a well-defined algebraic price level

The original dated consumption-good price is proportional to

\[
q_t=\beta^t c_t^{-\gamma}/(1+\tau_{c,t}).
\]

At constant consumption and taxes its recursion becomes `q_t=beta*q_(t-1)`. For beta between zero and one, dated prices decline. This is **not a unit root**; forcing a constant steady-state level gives q=0 and makes divisions by q problematic.

Deleting beta from that recursion removes the discount trend but gives `qtilde_t=qtilde_(t-1)` at a constant allocation. That leaves the level undetermined and has a unit root. This corrects the explanation in the preserved `RMT_FP_final.mod` and its duplicate development revision. Historical source bytes remain unchanged, with a linked erratum beside those sources.

The maintained models instead define the price level **algebraically**:

\[
\widetilde q_t=c_t^{-\gamma}/(1+\tau_{c,t}),\qquad
q_t=\beta^t\widetilde q_t.
\]

This fixes the level through marginal utility; it is not the undetermined detrended recursion. In Section 5.4, gamma=1 implements log consumption. The price equation therefore appears explicitly alongside the other equilibrium conditions and has a positive steady state at positive consumption.

Dated prices for yields are recovered after solving, normalized to q_0=1:

\[
q_t/q_0=\beta^t(c_t/c_0)^{-\gamma}
        (1+\tau_{c,0})/(1+\tau_{c,t}).
\]

The one-period pricing factor is `q_(t+1)/q_t`, retaining beta. Yields use `-log(q_(t+i)/q_t)/i` for positive maturities. The consumption-tax ratio is written explicitly even though it equals one in the spending experiment.

## Complete system and reduction

Section 4 has resource, detrended price, rental yield, wage, forward return, current payoff and Euler equations, matching (7)–(13). Section 5.3 matches (14)–(19), with current payoff definition (19a) included for interpretation. Section 5.4 matches (22)–(24), including the lettered price/payoff definitions and the labour condition.

Eliminating `qtilde`, `r`, `w`, `R` and `s` algebraically gives the two allocation equations in c and k, or three in c, k and n with elastic labour. The complete system is displayed and active for teaching; the earlier optional price epilogues have been superseded. `RBIG` from the 2025 code is the Euler-implied value of `R`, so it is not an independent equilibrium restriction.

The return equation expands the future rental yield in terms of today's capital choice (and future labour where applicable). This preserves its dependence on code `k` at the final simulated date; replacing that expression mechanically by a boundary value of `r(+1)` can create a singular terminal Jacobian. The time convention and economic equation are unchanged.

## What verbatim does

`verbatim; ... end;` copies ordinary MATLAB/Octave code unchanged into Dynare's generated program. It is not a Dynare `model` block. Use `%` comments inside it. The code now explains this at every active use: data export, scenario reset/storage, yield calculations and plots. The explicit price/return equations belong in `model`, not in a post-processing block.

All policy solves remain explicit. Output loops only read stored paths or fill fixed arrays; yield-loop comments state their dates, maturities and maximum price index. Independent checks compare the full and participant allocations and all active price/return definitions.

The guide uses this capital indexing directly throughout every model. A local footnote at the first capital mention in each model explains the convention. Production at t uses k_(t-1); accumulation chooses k_t; the Euler payoff in t+1 uses k_t. This is a notational relabelling, not a change to the numerical model.
