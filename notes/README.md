# Participant notes

Use `Code/sections` to study one exercise at a time. Use `Code/full_replications` to produce all figures for a section. Appendix A of the workbook lists the individual files.

Capital available at the beginning of period t is k_(t-1), written `k(-1)` in code. The choice made during t is k_t, written `k`. Production uses `k(-1)`; next period's rental payoff depends on `k`.

In fiscal exercises, simulation period 1 represents model date t=0. A policy change at t=10 starts in simulation period 11. The `values` in a deterministic `shocks` block are policy levels, not percentage changes.

| Command or object | Use |
|---|---|
| `steady` | Computes the steady state from the initial guesses and policy values |
| `check` | Reports the local roots and rank condition around the steady state |
| `initval` | Sets the initial policy and starting guesses for endogenous variables |
| `endval; steady;` | Computes the terminal steady state after a permanent policy change |
| `shocks(overwrite)` | Supplies the announced policy schedule and clears the preceding schedule |
| `perfect_foresight_setup` / `perfect_foresight_solver` | Sets up and solves a deterministic transition |
| `stoch_simul` | Approximates the stochastic model and computes simulation statistics and impulse responses |
| `order=2` | Requests a second-order approximation |
| `periods=1000` / `drop=100` | Simulates 1,000 observations; excludes the first 100 when reporting simulated moments |
| `irf=40` / `nograph` | Computes 40-period impulse responses and suppresses automatic plots |
| `set_dynare_seed(2025)` | Uses the same random-number sequence when the exercise is repeated |
| `varobs` | Identifies the observed variables used in estimation |
| `estimated_params` | Sets starting values and prior distributions for the estimated parameters |
| `mode_compute=4` / `mh_replic=1000` | Searches for the posterior mode and takes a short MCMC teaching sample |
| `verbatim; ... end;` | Copies ordinary MATLAB/Octave commands into the generated program; use `%` comments inside |
| `M_.endo_names`, `M_.exo_names` | Gives the variable names used to select a series with `strcmp` |
| `oo_.endo_simul` | Stores endogenous paths as rows |
| `oo_.exo_simul` | Stores exogenous paths as columns |
| `oo_.irfs` | Stores impulse responses, with field names such as `c_e` |
| `save` / transpose `'` | Saves named observations; the transpose makes a data column |
| Cells `{...}`, `for`, `subplot` | Stores scenario paths and draws the same set of panels for each exercise |

In these fiscal examples, endogenous column 1 is the initial condition, columns 2:301 are simulated dates and column 302 is the terminal condition. To plot capital available at t=0 use capital column 1; to plot consumption at t=0 use consumption column 2.

The full files solve each policy scenario explicitly, then use loops to draw the stored results. Between scenarios they restore the initial steady state and define the next terminal policy. None of the plotting loops changes the policy experiment.

A short MCMC chain illustrates estimation but does not establish convergence. The approximation examples generate second-order data; estimation uses the first-order likelihood. `drop` controls moment reporting and does not trim the saved simulation array.

See [prices and returns](q_and_auxiliaries.md) for the fiscal variables and the yield-curve calculation, and [figure_map.md](figure_map.md) for the figure files.
