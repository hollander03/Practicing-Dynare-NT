# Dated prices, real payoffs and optional auxiliaries

This note applies to Sections 4, 5.3 and 5.4. It also corrects the explanation beside the `q` recursion in the preserved `Code/training_2025/fiscal/RMT_FP_final.mod` (and its duplicate revision). The historical source is retained unchanged for provenance.

The worksheet uses the date-zero price of a consumption good delivered at date t:

\[
q_t=\beta^t c_t^{-\gamma}/(1+\tau_{c,t}),
\]

up to a common positive normalization. The corresponding recursion includes beta:

\[
q_t=\beta q_{t-1}(c_t/c_{t-1})^{-\gamma}
       (1+\tau_{c,t-1})/(1+\tau_{c,t}).
\]

At a constant allocation and constant taxes, this is `q_t = beta*q_(t-1)`. For beta between zero and one it describes declining dated prices. It is **not a unit root**. Forcing it into a constant steady-state equation yields `q=0`; subsequent `r/q`, `w/q` and `s/q` divisions can then be undefined or numerically unstable. A solver convergence message does not establish that the price normalization is meaningful.

Removing beta can be interpreted as detrending: define `q_tilde_t=q_t/beta^t`. But its recursion becomes `q_tilde_t=q_tilde_(t-1)` at a constant allocation. This leaves the level arbitrary and introduces a unit root in the recursive level. Dropping beta alone does **not** pin down a unique positive steady state. The 2025 comment reverses these two cases. Calling the result a “stationary kernel” is insufficient; an explicit level normalization or direct algebraic definition is required.

The normalized dated price can instead be calculated directly after solving allocations:

\[
q_t/q_0=\beta^t(c_t/c_0)^{-\gamma}
        (1+\tau_{c,0})/(1+\tau_{c,t}).
\]

The one-period pricing factor is `q_(t+1)/q_t`, and it retains beta. A detrended price **level** is not itself this one-period factor. Section 5.3.6 uses the dated prices for continuously compounded yields, `-log(q_(t+i)/q_t)/i`. The spending experiment has a constant zero consumption tax, so its tax ratio equals one; the code now retains that ratio explicitly.

## How the code preserves the useful quantities

| 2025 name | Meaning | Full-output model name | Optional short-file name |
|---|---|---|---|
| `r_over_q` | Current real marginal product of capital | `rental` | `r_over_q` |
| `w_over_q` | Current real wage; wage income when labour is normalized to one | `wage` | `w_over_q` |
| `s_over_q` | Current after-capital-tax payoff plus undepreciated capital | `saving_return` | `s_over_q` |
| `R` | Consumption-adjusted saving return R_(t+1), including applicable tax/subsidy wedges | `R` | Recovered through `RBIG` |
| `RBIG` | Return implied by the consumption Euler equation | Equals `R` in equilibrium | `RBIG` |

Real factor prices are computed directly from capital and labour. The dated-price factor cancels algebraically, so there is no need to create `q*rental` and then divide by `q`. `saving_return` is a realized current payoff; it is not interchangeable with the forward, consumption-adjusted `R`, especially when taxes or the investment subsidy vary over time. `RBIG` is useful for interpretation or checking the Euler equation, but is a duplicate of `R` in equilibrium, not another independent restriction.

Each short fiscal file has a fully commented **optional interpretation epilogue** after the solver (after the price/yield calculation in 5.3.6). Remove its opening and closing block-comment markers to activate it. It uses the solved paths and parameter values without adding endogenous variables or equations. The core resource/Euler/labour model remains unchanged, and the epilogue creates no figures. Capital available at a date comes from the previous capital choice; consumption and labour come from the current simulated column. Every resulting series uses the same dates.

The full-output files retain active auxiliary equations, with labels explaining their timing and units. These are the examples to use for the complete panels. The short epilogues offer the same interpretation in a separate learning step.

## Why the loops are limited and auditable

All policy scenarios are solved in explicit blocks. The full files' loops read stored solutions, select named rows, and fill fixed output columns or draw fixed panels. They do not iterate on policy rules or carry solver guesses between scenarios. The original baseline is restored explicitly before each solve.

The yield loops cover 61 dates and 40 maturities. Each cell is assigned once; the largest price index is 101, inside the 301-element price path. Maturity begins at one, avoiding division by zero. The code comments state these bounds. This makes the indexing checkable; it is not a claim that arbitrary future edits are safe. Execution checks also compare the short/full allocations and optional payoff calculations.
